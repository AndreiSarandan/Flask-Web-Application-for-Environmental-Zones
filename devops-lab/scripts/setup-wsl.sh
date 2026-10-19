#!/usr/bin/env bash
# Installs the DevOps Lab toolchain inside WSL2 Ubuntu 24.04.
# Idempotent: re-running skips tools that are already present.
# Docker itself comes from Docker Desktop (WSL integration), not from here.
set -euo pipefail

KUBECTL_VERSION="v1.31.4"
HELM_VERSION="v4.3.1"
KIND_VERSION="v0.33.0"

have() { command -v "$1" >/dev/null 2>&1; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT; cd "$tmp"

sudo apt-get update -y
sudo apt-get install -y unzip curl wget gnupg lsb-release ca-certificates

# AWS CLI v2
if ! have aws; then
  curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  unzip -q awscliv2.zip && sudo ./aws/install
fi

# Session Manager plugin (used by `aws ssm start-session` and Ansible's aws_ssm connection)
if ! have session-manager-plugin; then
  curl -sSL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o smp.deb
  sudo dpkg -i smp.deb
fi

# Terraform (HashiCorp apt repo)
if ! have terraform; then
  wget -qO- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  sudo apt-get update -y && sudo apt-get install -y terraform
fi

# GitHub CLI (official apt repo)
if ! have gh; then
  sudo mkdir -p -m 755 /etc/apt/keyrings
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update -y && sudo apt-get install -y gh
fi

# kubectl, helm, kind: pinned binaries into /usr/local/bin
if [ ! -x /usr/local/bin/kubectl ]; then
  curl -sSLo kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  sudo install -m 0755 kubectl /usr/local/bin/kubectl
fi
if ! have helm; then
  curl -sSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" | tar xz
  sudo install -m 0755 linux-amd64/helm /usr/local/bin/helm
fi
if ! have kind; then
  curl -sSLo kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
  sudo install -m 0755 kind /usr/local/bin/kind
fi

echo "--- versions"
aws --version
session-manager-plugin --version
terraform version | head -1
gh --version | head -1
/usr/local/bin/kubectl version --client | head -1
helm version --short
kind version
ansible --version | head -1
have docker && docker version --format 'docker server {{.Server.Version}}' \
  || echo "docker: enable Docker Desktop > Settings > Resources > WSL integration > Ubuntu-24.04"
