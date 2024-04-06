resource "aws_vpc" "of_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "of_gateway" {
  vpc_id = aws_vpc.of_vpc.id

  tags = {
    Name = var.gateway_name
  }
}

resource "aws_route_table" "of_rt" {
  vpc_id = aws_vpc.of_vpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.of_gateway.id
  }

  tags = {
    Name = var.route_table_name
  }
}

resource "aws_subnet" "of_public" {
  vpc_id                  = aws_vpc.of_vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_route_table_association" "of_rta_public" {
  subnet_id      = aws_subnet.of_public.id
  route_table_id = aws_route_table.of_rt.id
}