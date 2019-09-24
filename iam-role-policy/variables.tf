variable "region" {
    description = "Default AWS region"
    default     = "ap-south-1"
}

variable "vpc" {
    description = "Production VPC"
    default     = ""
}

variable "security-group" {
    description = "Production Security Group"
    default     = ""
}

variable "instance_type" {
    default = "t2.micro"
}