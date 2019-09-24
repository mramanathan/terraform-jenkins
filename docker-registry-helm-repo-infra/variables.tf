variable "region" {
    description = "Default AWS region"
    default     = "ap-south-1"
}

variable "public_security_group" {
    description = "Production Security Group"
    default     = "sg-0b33af29e71c46854"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ec2_keypair_name" {
  default = "cloud-deploy"
}

variable "public_subnet_id" {
  default = "subnet-00c9c231a8699a1cd"
}


variable "ec2_iam_instance_profile" {
  default = "EC2-iam-instance-profile"
}
