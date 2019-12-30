# ========== Pin provider version and cloud region
provider "aws" {
    region = "${var.aws_region}"
    version = "2.40.0"
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
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ecs_webserver_sg_tf"
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name                = "ecs_task_execution_role"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecs_task_execution_role_policy.json}"
}

data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
    role       = "${aws_iam_role.ecs_task_execution_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "ecs_alb" {
    name               = "ecs-alb-tf"
    internal           = false
    load_balancer_type = "application"
    security_groups    = ["${aws_security_group.ecs_webserver_sg.id}"]
    subnets            = split(",", "${var.subnet_ids}")

    tags = {
      Name = "ecs_alb_tf"
    }
}

resource "aws_lb_target_group" "ecs_alb_target_group" {
    name               = "ecs-alb-target-group-tf"
    port               = "80"
    protocol           = "HTTP"
    target_type        = "ip"
    vpc_id             = "${var.vpc_id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags = {
      Name = "ecs_alb_target_group_tf"
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = "${aws_alb.ecs_alb.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type              = "forward"
        target_group_arn  = "${aws_lb_target_group.ecs_alb_target_group.arn}"
    }
}

resource "aws_ecs_task_definition" "hostname" {
  family                   = "hostname-fargate-tf"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "name": "${var.container_name}",
    "family": "hostname-fargate-tf", 
    "image": "${var.image_url}",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "requiresCompatibilities": [
            "FARGATE"
    ],
    "memory": 500,
    "cpu": 256,
    "networkMode": "awsvpc"
  }
]
DEFINITION
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}
