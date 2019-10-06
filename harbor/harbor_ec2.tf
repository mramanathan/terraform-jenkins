provider "aws" {
    region = "${var.region}"
    version = "2.29"
}

terraform {
    backend "s3" {}
}

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

resource "aws_ebs_volume" "harbor_storage" {
    availability_zone = "${aws_instance.harbor_instance.availability_zone}"
    size = 8
    type = "gp2"

    tags = { 
        Name = "harbor_storage"
    }
}

resource "aws_volume_attachment" "harbor_ebs" {
    device_name = "/dev/sdf"
    volume_id   = "${aws_ebs_volume.harbor_storage.id}"
    instance_id = "${aws_instance.harbor_instance.id}"
}


resource "aws_instance" "harbor_instance" {
    ami                         = "${data.aws_ami.ubuntu.id}"
    instance_type               = "${var.instance_type}"

    vpc_security_group_ids      = ["${data.terraform_remote_state.vpc.outputs.public_security_group_id}"]
    subnet_id                   = "${data.terraform_remote_state.vpc.outputs.public_subnet_id}"
    associate_public_ip_address = true
    
    key_name                    = "${var.ec2_keypair_name}"
    
    iam_instance_profile        = "${var.ec2_iam_instance_profile}"

    tags = {
        Name = "Harbor-docker-registry-helm-chart-repo"
    }
}
