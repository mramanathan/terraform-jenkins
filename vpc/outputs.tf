output "vpc_id" {
  value = "${aws_vpc.production-vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.production-vpc.cidr_block}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public-subnet.id}"
}

output "public_security_group_id" {
  value = "${aws_security_group.ec2_public_security_group.id}"
}