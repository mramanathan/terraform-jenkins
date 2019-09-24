output "harbor_instance_dns_name" {
  value = "${aws_instance.harbor_instance.public_dns}"
}
