module "network" {
  source = "../modules/network"

  name     = "lab-dev"
  vpc_cidr = "10.20.0.0/16"
  subnets = {
    public-a       = { cidr = "10.20.0.0/24", az = "eu-central-1a", tier = "public" }
    public-b       = { cidr = "10.20.1.0/24", az = "eu-central-1b", tier = "public" }
    private-app-a  = { cidr = "10.20.10.0/24", az = "eu-central-1a", tier = "private-app" }
    private-app-b  = { cidr = "10.20.11.0/24", az = "eu-central-1b", tier = "private-app" }
    private-data-a = { cidr = "10.20.20.0/24", az = "eu-central-1a", tier = "private-data" }
    private-data-b = { cidr = "10.20.21.0/24", az = "eu-central-1b", tier = "private-data" }
  }
}

