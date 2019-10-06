output "jenkins_instance_dns_name" {
  value = "${aws_instance.jenkins_instance.public_dns}"
}
