variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecr_repository_name" {
  type = string
}

variable "sshkey" {
  type = string
}

# set from TF_VAR_local_ipaddress that takes output of curl ifconfig.co
variable "local_ip_address" {}
