# ========== Pin provider version and cloud region
provider "aws" {
    region = "${var.aws_region}"
    version = "2.40.0"
}

# ========== Template provider
provider "template" {
    version = "2.1"
}

# ========== Prep the EC2 with python and ansible
data "template_file" "user_data" {
    template = "${file("${path.module}/templates/user_data.tpl")}"
}

# ========== security group: permit ssh traffic
resource "aws_security_group" "ecs_webserver_sg" {
    name        = "ecs_webserver_sg"
    description = "Allow inbound and outbound traffic"
    vpc_id      = "${var.vpc_id}"

    ingress {
        from_port = 0
        to_port   = 65535
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

aws "aws_iam_role" "ecs_agent" {
    name = "ecs_agent"
    assume_role_policy = "${data.aws_iam_policy_document.ecs_agent.json}"
}

aws "aws_iam_policy_document" "ecs_agent" {
    statement {
        actions = ["sts:AssumeRole"]

        principals = {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
    role = "${aws_iam_role.ecs_agent.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_launch_configuration" "ecs_launch_config" {
    name_prefix = "tf-ecs-instance-launch-config-example-"
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
    image_id = "ami-0310a9b646b817d26"
    iam_instance_profile = "${aws.iam_instance_profile.ecs_agent.name}"
    security_groups = "${aws_security_group.ecs_webserver_sg.id}"
    user_data = "${data.template_file.user_data.rendered}"
    instance_type = "t2.micro"

    root_block_device {
        volume_type = "standard"
        volume_size = 100
        delete_on_termination = true
    }

    associate_public_ip_address = "false"
    key_name = "${var.sshkey}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs_agent"
  role = "${aws_iam_role.ecs_agent.name}"
}

data "template_file" "user_data" {
    template = "${file("${module.path}"/user_data.tpl)}"
    
    vars {
        ecs_cluster = "ecs_webserver"
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

resource "aws_ecs_cluster" "ecs_webserver" {
  name = "ecs_webserver"
}
