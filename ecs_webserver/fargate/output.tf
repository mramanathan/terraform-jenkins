output "ecs_cluster_name" {
    value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "aws_alb_dns" {
  value = "${aws_alb.ecs_alb.dns_name}"
}