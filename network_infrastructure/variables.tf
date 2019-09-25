variable "region" {
  default     = "ap-south-1"
  description = "Default AWS region of clouddeploy"
}

variable "vpc_cidr" {
    description = "Production VPC CIDE Block"
    default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
    description = "Public Subnet 1 CIDR"  
}