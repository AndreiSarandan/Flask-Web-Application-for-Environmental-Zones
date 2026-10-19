provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Project   = "devops-lab"
      Env       = "dev"
      ManagedBy = "terraform"
    }
  }
}
