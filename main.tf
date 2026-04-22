provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = "ALB-PROJ-VPC"
  }
}

resource "aws_subnet" "ps" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.pub_cidr_blocks[count.index]
  availability_zone = var.avz_zone[count.index]
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true
  tags = {
    Name = "ALB-PROJ-PS-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ALB-PROJ-IGW"
  }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "ALB-PROJ-RTB"
  }
}

resource "aws_route_table_association" "rta" {
    count = 2
    subnet_id = aws_subnet.ps[count.index].id
    route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sgw" {
  name = "WEB"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allowing SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP Traffic"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
  }

  egress {
    description = "Outbound traffic"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
  tags = {
    Name = "ALB-PROJ-SGW"
  }
}

resource "aws_instance" "name" {
    instance_type = var.instance_type
    ami = var.ami
    count = 2
    associate_public_ip_address = true
    user_data = file("install_nginx.sh")
    vpc_security_group_ids = [aws_security_group.sgw.id]
    subnet_id = aws_subnet.ps[count.index].id
    tags = {
      Name = "ALB-PROJ-${count.index + 1}"
    }
}

