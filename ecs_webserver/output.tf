output "ecs_cluster_name" {
    value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "ecr_info" {
    value = "{aws_ecr_repository.ecr_repository_name.repository_url}"
}