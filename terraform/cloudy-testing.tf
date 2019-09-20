provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_vpc" "mainvpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.mainvpc.id
    cidr_block = var.private_subnet
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Environment = var.environment_tag
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.mainvpc.id
    tags = {
        Environment = var.environment_tag
    }
}

resource "aws_route_table" "rtb_public" {
    vpc_id = aws_vpc.mainvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
     }
    tags = {
        Environment = var.environment_tag
    }
}

resource "aws_route_table_association" "rta_public_subnet" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "sg_ssh_in" {
    name = "sg_ssh_in"
    vpc_id = aws_vpc.mainvpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Environment = var.environment_tag
    }
}

resource "aws_instance" "munmasiina" {
  ami = "ami-00aa4671cbf840d82"
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [ aws_security_group.sg_ssh_in.id ]

  # provisioner "local-exec" {
  #     command = "echo ${aws_instance.munmasiina.public_ip} > public-ip.txt"
  # }
}

output "hostname" {
    value = aws_instance.munmasiina.public_dns
}

output "instance_id" {
    value = aws_instance.munmasiina.id
}
