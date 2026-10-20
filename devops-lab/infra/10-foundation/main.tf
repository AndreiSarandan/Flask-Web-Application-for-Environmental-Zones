locals {
  subnets = {
    public-a       = { cidr = "10.20.0.0/24", az = "eu-central-1a", tier = "public" }
    public-b       = { cidr = "10.20.1.0/24", az = "eu-central-1b", tier = "public" }
    private-app-a  = { cidr = "10.20.10.0/24", az = "eu-central-1a", tier = "private-app" }
    private-app-b  = { cidr = "10.20.11.0/24", az = "eu-central-1b", tier = "private-app" }
    private-data-a = { cidr = "10.20.20.0/24", az = "eu-central-1a", tier = "private-data" }
    private-data-b = { cidr = "10.20.21.0/24", az = "eu-central-1b", tier = "private-data" }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_support   = true # Amazon DNS resolver (VPC base +2) answers queries inside the VPC
  enable_dns_hostnames = true # instances get DNS names; required for private endpoints, RDS, EKS

  tags = {
    Name = "lab-dev-vpc"
  }
}

resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id            = aws_vpc.main.id # implicit dependency: subnet is created after the VPC
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "lab-dev-${each.key}"
    Tier = each.value.tier # upper layers find subnets by this tag
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "lab-dev-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "lab-dev-public"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = { for k, v in local.subnets : k => v if v.tier == "public" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = toset(["private-app", "private-data"])

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "lab-dev-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = { for k, v in local.subnets : k => v if v.tier != "public" }

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[each.value.tier].id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in aws_route_table.private : rt.id] # adds an S3 route to each private RT

  tags = {
    Name = "lab-dev-s3"
  }
}
