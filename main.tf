terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "open_fortress_instance" {
  source = "./modules/open_fortress_instance"

  github_username = var.github_username
  aws_region      = var.aws_region

  ebs_disk_size     = var.ebs_disk_size
  ebs_volume_type   = var.ebs_volume_type
  ec2_instance_name = var.ec2_instance_name
  ec2_instance_type = var.ec2_instance_type
  ec2_ami_id        = var.ec2_ami_id

  vpc_cidr_block         = var.vpc_cidr_block
  vpc_name               = var.vpc_name
  gateway_name           = var.gateway_name
  route_table_cidr_block = var.route_table_cidr_block
  route_table_name       = var.route_table_name
  subnet_cidr_block      = var.subnet_cidr_block
  subnet_name            = var.subnet_name
}