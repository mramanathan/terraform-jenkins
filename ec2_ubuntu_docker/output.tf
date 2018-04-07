output "ec2_instance" {
    value = "${aws_instance.tf_ec2_instance.*.id}"
}

output "ec2_instance_public_ip" {
    value = "${aws_instance.tf_ec2_instance.*.public_ip}"
}
