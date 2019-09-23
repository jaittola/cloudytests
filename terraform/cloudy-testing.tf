provider "aws" {
  profile = "default"
  region = var.region
}

data "aws_availability_zones" "available" {
}
