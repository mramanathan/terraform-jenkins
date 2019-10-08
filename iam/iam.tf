provider "aws" {
    region = "${var.region}"
    version = "2.29"
}

terraform {
    backend "s3" {}
}

resource "aws_iam_role" "ec2_iam_role" {
    name = "ec2_iam_role"
    assume_role_policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
        {
            "Action" : "sts:AssumeRole",
            "Principal" : {
                "Service" : "ec2.amazonaws.com"
            },
            "Effect" : "Allow",
            "Sid" : ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_iam_role_policy" {
    name = "ec2_iam_role_policy"
    role = "${aws_iam_role.ec2_iam_role.id}"
    policy = <<EOF
{
    "Version" : "2012-10-17",
    "Statement" : [
        {
            "Action" : [
                "ec2:*",
                "s3:*",
                "cloudwatch:*",
                "logs:*"
            ],
            "Effect" : "Allow",
            "Resource" : "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "ec2_iam_instance_profile"
    role = "${aws_iam_role.ec2_iam_role.name}"
}