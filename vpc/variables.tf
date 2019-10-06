variable "region" {
  default     = "ap-south-1"
  description = "Default AWS region of clouddeploy"
}

variable "vpc_cidr" {
    description = "Production VPC CIDE Block"
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "Public Subnet CIDR"  
}

variable "public_security_group_ingress_1_cidr" {
    description = "Public Subnet Ingress CIDR to allow traffic from corp network"  
}

variable "public_security_group_ingress_2_cidr" {
    description = "Public Subnet Ingress CIDR to allow traffic from home network"  
}