output "ec2_instance_profile" {
  value = "${aws_iam_instance_profile.ec2_instance_profile.name}"
}

output "ec2_iam_role" {
  value = "${aws_iam_role.ec2_iam_role.name}"
}

output "ec2_iam_role_policy" {
  value = "${aws_iam_role_policy.ec2_iam_role_policy.name}"
}
