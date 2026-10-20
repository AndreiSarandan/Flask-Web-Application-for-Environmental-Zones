terraform {
  backend "s3" {
    bucket       = "devops-lab-tfstate-678530698532-eu-central-1-an"
    key          = "dev/00-bootstrap/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }
}
