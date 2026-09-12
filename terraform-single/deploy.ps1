param(
    [switch]$AutoApprove
)

$ErrorActionPreference = "Stop"
$Profile = "lez-demo"
$Region = "eu-central-1"
$ParameterName = "/lez-demo/runtime"
$Root = Split-Path -Parent $PSScriptRoot
$EnvPath = Join-Path $Root ".env"

if (-not (Test-Path -LiteralPath $EnvPath)) {
    throw ".env not found at $EnvPath"
}

aws sts get-caller-identity --profile $Profile --region $Region --output json | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "AWS profile '$Profile' is not authenticated. Run: aws login --profile $Profile --region $Region"
}

$vars = @{}
foreach ($line in Get-Content -LiteralPath $EnvPath) {
    $text = $line.Trim()
    if (-not $text -or $text.StartsWith("#") -or -not $text.Contains("=")) { continue }
    $index = $text.IndexOf("=")
    $key = $text.Substring(0, $index).Trim()
    $value = $text.Substring($index + 1).Trim().Trim('"').Trim("'")
    $vars[$key] = $value
}

if (-not $vars["DOCKERHUB_USERNAME"] -or -not $vars["DOCKERHUB_TOKEN"]) {
    throw "DOCKERHUB_USERNAME and DOCKERHUB_TOKEN are required in .env"
}

function New-HexSecret([int]$Bytes = 24) {
    $buffer = New-Object byte[] $Bytes
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    try { $rng.GetBytes($buffer) } finally { $rng.Dispose() }
    return -join ($buffer | ForEach-Object { $_.ToString("x2") })
}

$runtime = @{
    SECRET_KEY             = New-HexSecret 32
    MYSQL_ROOT_PASSWORD    = New-HexSecret 24
    MYSQL_DB               = "flask_lez_db_aws"
    MYSQL_USER             = "lezapp"
    MYSQL_PASS             = New-HexSecret 24
    GRAFANA_ADMIN_PASSWORD = New-HexSecret 18
    DOCKERHUB_USERNAME     = $vars["DOCKERHUB_USERNAME"]
    DOCKERHUB_TOKEN        = $vars["DOCKERHUB_TOKEN"]
} | ConvertTo-Json -Compress

aws ssm put-parameter `
    --profile $Profile `
    --region $Region `
    --name $ParameterName `
    --description "LEZ demo runtime credentials; created outside Terraform to keep plaintext out of tfstate" `
    --type SecureString `
    --value $runtime `
    --overwrite `
    --output json | Out-Null

if ($LASTEXITCODE -ne 0) {
    throw "Could not create the SSM runtime parameter"
}

terraform -chdir=$PSScriptRoot init
if ($LASTEXITCODE -ne 0) { throw "terraform init failed" }

terraform -chdir=$PSScriptRoot validate
if ($LASTEXITCODE -ne 0) { throw "terraform validate failed" }

$planPath = Join-Path $PSScriptRoot "lez-demo.tfplan"
terraform -chdir=$PSScriptRoot plan -out=$planPath
if ($LASTEXITCODE -ne 0) { throw "terraform plan failed" }

if ($AutoApprove) {
    terraform -chdir=$PSScriptRoot apply -auto-approve $planPath
} else {
    terraform -chdir=$PSScriptRoot apply $planPath
}
if ($LASTEXITCODE -ne 0) { throw "terraform apply failed" }

terraform -chdir=$PSScriptRoot output

