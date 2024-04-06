module "networking" {
  source = "../networking"

  vpc_cidr_block         = var.vpc_cidr_block
  vpc_name               = var.vpc_name
  gateway_name           = var.gateway_name
  route_table_cidr_block = var.route_table_cidr_block
  route_table_name       = var.route_table_name
  subnet_cidr_block      = var.subnet_cidr_block
  subnet_name            = var.subnet_name
}

resource "aws_instance" "open_fortress" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [module.networking.security_group_id]
  subnet_id              = module.networking.public_subnet_id

  root_block_device {
    volume_size           = var.ebs_disk_size
    volume_type           = var.ebs_volume_type
    delete_on_termination = true
  }

  tags = {
    Name = var.ec2_instance_name
  }

  user_data = data.template_file.ec2_setup_script.rendered
}

resource "aws_eip" "lb" {
  instance = aws_instance.open_fortress.id
  domain   = "vpc"
}
