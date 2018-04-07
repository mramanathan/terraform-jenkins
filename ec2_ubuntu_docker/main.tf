#################################################
#
# Tested with Terraform v0.12.16
#
#################################################

# ========== Pin provider version and cloud region
provider "aws" {
    region = "${var.aws_region}"
    version = "2.40.0"
}

# ========== Template provider
provider "template" {
    version = "2.1"
}

# ========== Ubuntu 18.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ========== Prep the EC2 with python and ansible
data "template_file" "user_data" {
    template = "${file("${path.module}/templates/user_data.tpl")}"
}

# ========== security group: permit ssh traffic
resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh"
    description = "Allow inbound SSH traffic"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        # in lieu of blanket access to ec2 instance, restrict just to ip address
        # To get ip address of your system, use, curl ifconfig.co
        cidr_blocks = ["${var.local_ip_address}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# ========== Spin up EC2 instances
resource "aws_instance" "tf_ec2_instance" {
    count                  = "${var.ec2_count}"
    ami                    = "${data.aws_ami.ubuntu.id}"
    instance_type          = "t2.micro"
    associate_public_ip_address = true
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
    key_name               = "${var.sshkey}"

    user_data              = "${data.template_file.user_data.rendered}"

    tags = {
        Name = "tf-ec2-instance-${count.index}"
    }
}
