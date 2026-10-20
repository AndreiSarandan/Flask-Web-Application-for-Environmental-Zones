variable "name" {
  description = "Prefix for Name tags, e.g. lab-dev"
  type        = string
}

variable "subnets" {
  description = "Subnets keyed by name; tier is public, private-app or private-data"
  type = map(object({
    cidr = string
    az   = string
    tier = string
  }))
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}
