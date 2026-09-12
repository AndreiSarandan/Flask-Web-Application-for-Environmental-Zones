# Wrapper: loads ../.env, maps values to TF_VAR_* env vars, then runs terraform.
# Usage:  .\tf.ps1 init  |  .\tf.ps1 plan  |  .\tf.ps1 apply  |  .\tf.ps1 destroy
# Secrets live ONLY in .env - never in any .tf / .tfvars file.

param([Parameter(ValueFromRemainingArguments = $true)] $TfArgs)

$ErrorActionPreference = "Stop"
$envPath = Join-Path $PSScriptRoot "..\.env"
if (-not (Test-Path $envPath)) { throw ".env not found at $envPath" }

# Parse KEY=VALUE lines (skip comments / blanks), strip optional surrounding quotes
$vars = @{}
foreach ($line in Get-Content $envPath) {
    $t = $line.Trim()
    if (-not $t -or $t.StartsWith("#") -or -not $t.Contains("=")) { continue }
    $i = $t.IndexOf("=")
    $k = $t.Substring(0, $i).Trim()
    $v = $t.Substring($i + 1).Trim().Trim('"').Trim("'")
    $vars[$k] = $v
}

# Map .env -> Terraform input variables
$env:TF_VAR_secret_key  = $vars["SECRET_KEY"]
$env:TF_VAR_db_password = $vars["MYSQL_PASS"]
$env:TF_VAR_db_username = $vars["MYSQL_USER"]
$env:TF_VAR_db_name     = $vars["MYSQL_DB"]

# Derive region + RDS identifier from the host:
#   <identifier>.<random>.<region>.rds.amazonaws.com
$hostParts = $vars["MYSQL_HOST"].Split(".")
$env:TF_VAR_existing_db_identifier = $hostParts[0]
$env:TF_VAR_region                 = $hostParts[2]

# AWS credentials for the provider (standard SDK env vars). Note: .env key is
# named ACCES_KEY (single S) - kept as-is to match the existing file.
$env:AWS_ACCESS_KEY_ID     = $vars["ACCES_KEY"]
$env:AWS_SECRET_ACCESS_KEY = $vars["SECRET_ACCESS_KEY"]
$env:AWS_DEFAULT_REGION    = $hostParts[2]

# Docker Hub (private repo) - token required; username falls back to the variable default
$env:TF_VAR_dockerhub_token = $vars["DOCKERHUB_TOKEN"]
if ($vars["DOCKERHUB_USERNAME"]) { $env:TF_VAR_dockerhub_username = $vars["DOCKERHUB_USERNAME"] }

Write-Host "[tf.ps1] Loaded .env -> RDS '$($hostParts[0])' in region '$($hostParts[2])' (secrets injected via TF_VAR_*)" -ForegroundColor Cyan
Write-Host "[tf.ps1] AWS credentials loaded from .env (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)." -ForegroundColor DarkGray

terraform @TfArgs
