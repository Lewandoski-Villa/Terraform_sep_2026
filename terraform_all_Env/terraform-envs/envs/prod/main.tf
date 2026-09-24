terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Optional: remote state per environment (recommended for teams)
  # backend "s3" {
  #   bucket = "your-tfstate-bucket"
  #   key    = "myapp/<env>/terraform.tfstate"   # dev / uat / prod
  #   region = "ap-south-1"
  # }
}

# Credentials come from your existing `aws configure`
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env_prefix
      ManagedBy   = "terraform"
    }
  }
}

variable "region" {
  default = "ap-south-1"
}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env_prefix" {}
variable "avail_zone" {}
variable "my_ip" {}
variable "instance_type" {}

module "myapp" {
  source = "../../modules/myapp-env"

  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  env_prefix        = var.env_prefix
  avail_zone        = var.avail_zone
  my_ip             = var.my_ip
  instance_type     = var.instance_type
}

output "aws_vpc"                     { value = module.myapp.aws_vpc }
output "aws_subnet"                  { value = module.myapp.aws_subnet }
output "aws_internet_gateway"        { value = module.myapp.aws_internet_gateway }
output "aws_route_table"             { value = module.myapp.aws_route_table }
output "aws_route_table_association" { value = module.myapp.aws_route_table_association }
output "aws_security_group"          { value = module.myapp.aws_security_group }
output "server_public_ip"            { value = module.myapp.server_public_ip }
output "server_private_ip"           { value = module.myapp.server_private_ip }
