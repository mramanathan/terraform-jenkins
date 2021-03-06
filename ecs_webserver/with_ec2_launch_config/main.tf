# ========== Pin provider version and cloud region
provider "aws" {
    region = "${var.aws_region}"
    version = "2.40.0"
}

# ========== Template provider
provider "template" {
    version = "2.1"
}


# ========== AWS ECR setup
resource "aws_ecr_repository" "ecr_repository_name" {
  name = "${var.ecr_repository_name}"
}

# ========== security group: permit ssh and web traffic
resource "aws_security_group" "ecs_webserver_sg" {
    name        = "ecs_webserver_sg"
    description = "Allow inbound and outbound traffic"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        # in lieu of blanket access to ec2 instance, restrict just to ip address
        # To get ip address of your system, use, curl ifconfig.co
        cidr_blocks = ["${var.local_ip_address}/32"]
    }

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        # in lieu of blanket access to ec2 instance, restrict just to ip address
        # To get ip address of your system, use, curl ifconfig.co
        cidr_blocks = ["${var.local_ip_address}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_iam_role" "ecs-instance-role" {
    name                = "ecs-instance-role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}

data "aws_iam_policy_document" "ecs-instance-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
    role       = "${aws_iam_role.ecs-instance-role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
    name = "ecs-instance-profile"
    path = "/"
    role = "${aws_iam_role.ecs-instance-role.name}"
    provisioner "local-exec" {
      command = "sleep 10"
    }
}

resource "aws_launch_configuration" "ecs_launch_config" {
    name_prefix = "tf-ecs-launch-config-instance-"
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
    image_id = "ami-0310a9b646b817d26"
    iam_instance_profile = "${aws.iam_instance_profile.ecs_agent.name}"
    security_groups = "${aws_security_group.ecs_webserver_sg.id}"
    instance_type = "t2.micro"
    associate_public_ip_address = "false"
    key_name = "${var.sshkey}"

    user_data = <<EOF
                #!/bin/bash
                echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
                EOF

    root_block_device {
        volume_type = "standard"
        volume_size = 100
        delete_on_termination = true
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "ecs_webserver_asg" {
    name = "ecs_webserver_asg"
    launch_configuration = "${aws_launch_configuration.ecs_launch_config.name}"

    min_size = 1
    max_size = 2

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}
