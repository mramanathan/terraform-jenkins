variable "region" {
  description = "Default AWS region"
  default     = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_keypair_name" {
  description = "Key pair to access EC2 instance"
}

variable "ec2_iam_instance_profile" {
  description = "Enable EC2 instance to assume IAM role"
}
