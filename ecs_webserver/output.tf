output "ecs_cluster_name" {
    value = "${aws.aws_ecs_cluter.name}"
}

output "ecr_info" {
    value = "{aws_ecr_repository.ecs_webserver_images.repository_url}"
}