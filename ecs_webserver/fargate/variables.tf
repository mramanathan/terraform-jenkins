variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

# comma separated subnet id
variable "subnet_ids" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "image_url" {
  type = string
}