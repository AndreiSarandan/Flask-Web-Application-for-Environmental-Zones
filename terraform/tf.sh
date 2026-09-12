#!/usr/bin/env bash
# Wrapper: loads ../.env, maps values to TF_VAR_* env vars, then runs terraform.
# Usage:  ./tf.sh init | ./tf.sh plan | ./tf.sh apply | ./tf.sh destroy
# Secrets live ONLY in .env - never in any .tf / .tfvars file.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
[ -f "$ENV_FILE" ] || { echo ".env not found at $ENV_FILE" >&2; exit 1; }

# Load .env (ignore comments/blanks)
set -a
# shellcheck disable=SC1090
source <(grep -vE '^\s*(#|$)' "$ENV_FILE")
set +a

# Map .env -> Terraform input variables
export TF_VAR_secret_key="${SECRET_KEY}"
export TF_VAR_db_password="${MYSQL_PASS}"
export TF_VAR_db_username="${MYSQL_USER}"
export TF_VAR_db_name="${MYSQL_DB}"

# Derive region + RDS identifier from <identifier>.<random>.<region>.rds.amazonaws.com
IFS='.' read -r -a HP <<< "$MYSQL_HOST"
export TF_VAR_existing_db_identifier="${HP[0]}"
export TF_VAR_region="${HP[2]}"

# AWS credentials for the provider (standard SDK env vars).
# .env key is named ACCES_KEY (single S) - kept as-is to match the existing file.
export AWS_ACCESS_KEY_ID="${ACCES_KEY}"
export AWS_SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${HP[2]}"

# Docker Hub (private repo) - token required; username falls back to variable default
export TF_VAR_dockerhub_token="${DOCKERHUB_TOKEN:-}"
[ -n "${DOCKERHUB_USERNAME:-}" ] && export TF_VAR_dockerhub_username="${DOCKERHUB_USERNAME}"

echo "[tf.sh] Loaded .env -> RDS '${HP[0]}' in region '${HP[2]}' (secrets injected via TF_VAR_*)"
echo "[tf.sh] AWS credentials loaded from .env (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)."

exec terraform "$@"
