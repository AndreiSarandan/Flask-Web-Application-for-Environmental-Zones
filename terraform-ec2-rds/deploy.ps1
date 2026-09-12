param([switch]$AutoApprove)

$ErrorActionPreference = "Stop"
$Profile = "lez-demo"
$Region = "eu-central-1"
$ParameterName = "/lez-demo/app-runtime"
$Root = Split-Path -Parent $PSScriptRoot
$EnvPath = Join-Path $Root ".env"

aws sts get-caller-identity --profile $Profile --region $Region --output json | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "Authenticate first: aws login --profile $Profile --region $Region"
}

$null = aws ssm get-parameter --profile $Profile --region $Region --name $ParameterName --output text 2>$null
if ($LASTEXITCODE -ne 0) {
    $vars = @{}
    foreach ($line in Get-Content -LiteralPath $EnvPath) {
        $text = $line.Trim()
        if (-not $text -or $text.StartsWith("#") -or -not $text.Contains("=")) { continue }
        $index = $text.IndexOf("=")
        $vars[$text.Substring(0, $index).Trim()] = $text.Substring($index + 1).Trim().Trim('"').Trim("'")
    }

    if (-not $vars["DOCKERHUB_USERNAME"] -or -not $vars["DOCKERHUB_TOKEN"]) {
        throw "DOCKERHUB_USERNAME and DOCKERHUB_TOKEN are required in .env"
    }

    function New-HexSecret([int]$Bytes) {
        $buffer = New-Object byte[] $Bytes
        $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
        try { $rng.GetBytes($buffer) } finally { $rng.Dispose() }
        return -join ($buffer | ForEach-Object { $_.ToString("x2") })
    }

    $runtime = @{
        SECRET_KEY             = New-HexSecret 32
        GRAFANA_ADMIN_PASSWORD = New-HexSecret 18
        DOCKERHUB_USERNAME     = $vars["DOCKERHUB_USERNAME"]
        DOCKERHUB_TOKEN        = $vars["DOCKERHUB_TOKEN"]
    } | ConvertTo-Json -Compress

    $parameterPayload = @{
        Name        = $ParameterName
        Description = "LEZ Flask, Grafana and Docker Hub runtime credentials"
        Type        = "SecureString"
        Value       = $runtime
    } | ConvertTo-Json
    $parameterFile = Join-Path ([IO.Path]::GetTempPath()) ("lez-ssm-" + [guid]::NewGuid().ToString("N") + ".json")
    try {
        [IO.File]::WriteAllText($parameterFile, $parameterPayload, [Text.UTF8Encoding]::new($false))
        $parameterUri = "file://" + $parameterFile.Replace([char]92, [char]47)
        aws ssm put-parameter `
            --profile $Profile `
            --region $Region `
            --cli-input-json $parameterUri `
            --output json | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Could not create $ParameterName" }
    } finally {
        Remove-Item -LiteralPath $parameterFile -Force -ErrorAction SilentlyContinue
    }
}

terraform "-chdir=$PSScriptRoot" init -input=false
if ($LASTEXITCODE -ne 0) { throw "terraform init failed" }

terraform "-chdir=$PSScriptRoot" validate
if ($LASTEXITCODE -ne 0) { throw "terraform validate failed" }

terraform "-chdir=$PSScriptRoot" plan -input=false -out=lez-demo.tfplan
if ($LASTEXITCODE -ne 0) { throw "terraform plan failed" }

if ($AutoApprove) {
    terraform "-chdir=$PSScriptRoot" apply -input=false -auto-approve lez-demo.tfplan
} else {
    terraform "-chdir=$PSScriptRoot" apply -input=false lez-demo.tfplan
}
if ($LASTEXITCODE -ne 0) { throw "terraform apply failed" }

terraform "-chdir=$PSScriptRoot" output

