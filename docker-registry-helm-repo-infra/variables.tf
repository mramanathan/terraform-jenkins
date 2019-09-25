variable "region" {
    description = "Default AWS region"
    default     = "ap-south-1"
}

variable "public_security_group" {
    description = "Production Security Group"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ec2_keypair_name" {
  description = "Key pair to access EC2 instance"
}

variable "public_subnet_id" {
  description = "EC2 instance will be in this subnet"
}


variable "ec2_iam_instance_profile" {
  description = "Enable EC2 instance to assume IAM role"
}
