variable "aws_region" {
  type = string
}

# set from TF_VAR_local_ipaddress that takes output of curl ifconfig.co
variable "worker_count" {
  type = string
  default = "2"
}

variable "vpc_id" {
  type = string
}

# set from TF_VAR_local_ipaddress that takes output of curl ifconfig.co
variable "subnet_id" {
  type = string
}

variable "key_path" {
  type = string
  description = "SSH public key's path"
  default = "/tmp/id_rsa.pub"
}