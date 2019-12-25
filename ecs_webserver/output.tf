output "ecs_cluster_name" {
    value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "ecr_info" {
    value = "{aws_ecr_repository.ecr_repository_name.repository_url}"
}

output "ec2_instance" {
    value = "${aws_instance.tf_ecs_instance.*.id}"
}

output "ec2_instance_public_ip" {
    value = "${aws_instance.tf_ecs_instance.*.public_ip}"
}