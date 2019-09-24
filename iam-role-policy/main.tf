provider "aws" {
    region = "${var.region}"
}

resource "aws_iam_role" "ec2_iam_role" {
    name = "EC2-iam-role"
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
    name = "EC2-iam-role-policy"
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
    name = "EC2-iam-instance-profile"
    role = "${aws_iam_role.ec2_iam_role.name}"
}
