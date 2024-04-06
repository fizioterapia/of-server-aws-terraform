variable "github_username" {
  type        = string
  default     = "fizioterapia"
  description = "The GitHub username used for SSH access and redirect"
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "The AWS region where resources will be provisioned"
}

variable "ebs_disk_size" {
  type        = number
  default     = 30
  description = "Size of the EBS disk in gigabytes"
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp3"
  description = "Type of EBS volume (e.g., gp2, gp3, io1, io2)"
}

variable "ec2_instance_name" {
  type        = string
  default     = "open_fortress_ec2"
  description = "Name of the EC2 instance"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Type of EC2 instance (e.g., t2.micro, t3.small)"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-0e626c31414223120"
  description = "AMI ID for the EC2 instance"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  default     = "of_vpc"
  description = "Name of the VPC"
}

variable "gateway_name" {
  type        = string
  default     = "of_gateway"
  description = "Name of the Internet Gateway"
}

variable "route_table_cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR block for the route table"
}

variable "route_table_name" {
  type        = string
  default     = "of_rt"
  description = "Name of the route table"
}

variable "subnet_cidr_block" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for the subnet"
}

variable "subnet_name" {
  type        = string
  default     = "of_public_subnet"
  description = "Name of the subnet"
}
