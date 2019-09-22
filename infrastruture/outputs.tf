output "vpc_id" {
  value = "${aws_vpc.production-vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.production-vpc.cidr_block}"
}

output "public_subnet_1_id" {
  value = "${aws_subnet.public-subnet-1.id}"
}