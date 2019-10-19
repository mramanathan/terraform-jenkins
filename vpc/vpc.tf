provider "aws" {
  region = "${var.region}"
  version = "2.29"
}

terraform {
    backend "s3" {}
}

resource "aws_vpc" "production-vpc" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_hostnames = true

    tags = {
        Name = "Production VPC in ${var.region}"
    }
}

resource "aws_security_group" "ec2_public_security_group" {
  description = "EC2 Public Security Group"
  name        = "ec2_public_security_group"
  vpc_id      = "${aws_vpc.production-vpc.id}"

  ingress {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["${var.public_security_group_ingress_1_cidr}"]
  }
  
  ingress {
      from_port = 1729
      to_port   = 1729
      protocol  = "tcp"
      cidr_blocks = ["${var.public_security_group_ingress_1_cidr}"]
  }

  ingress {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["${var.public_security_group_ingress_2_cidr}"]
  }
  
  ingress {
      from_port = 1729
      to_port   = 1729
      protocol  = "tcp"
      cidr_blocks = ["${var.public_security_group_ingress_2_cidr}"]
  }

  ingress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "ec2_traffic"
  }
}

resource "aws_subnet" "public-subnet" {
    vpc_id            = "${aws_vpc.production-vpc.id}"
    cidr_block        = "${var.public_subnet_cidr}"
    availability_zone = "ap-south-1a"

    tags = {
        Name = "Public-Subnet"
    }
}

resource "aws_route_table" "public-route-table" {
    vpc_id = "${aws_vpc.production-vpc.id}"

    tags = {
        Name = "Public-Route-Table"
    }
}

resource "aws_route_table_association" "public-subnet-association" {
    route_table_id = "${aws_route_table.public-route-table.id}"
    subnet_id      = "${aws_subnet.public-subnet.id}"  
}

resource "aws_internet_gateway" "production-igw" {
    vpc_id         = "${aws_vpc.production-vpc.id}"

    tags = {
        Name = "Production-IGW"
    }
}

resource "aws_route" "public-internet-gw-route" {
    route_table_id         = "${aws_route_table.public-route-table.id}"
    gateway_id             = "${aws_internet_gateway.production-igw.id}"
    destination_cidr_block = "0.0.0.0/0"
}