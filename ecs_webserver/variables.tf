variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "sshkey" {
  type = string
}

# set from TF_VAR_local_ipaddress that takes output of curl ifconfig.co
variable "local_ip_address" {}
