output "swarm_manager" {
    value = "${aws_instance.swarm_manager.id}"
}

output "swarm_manager_private_ip" {
    value = "${aws_instance.swarm_manager.private_ip}"
}

output "swarm_manager_public_ip" {
    value = "${aws_instance.swarm_manager.public_ip}"
}

output "swarm_worker" {
    value = "${aws_instance.swarm_worker.*.id}"
}
output "swarm_worker_public_ip" {
    value = "${aws_instance.swarm_worker.*.public_ip}"
}

output "swarm_worker_private_ip" {
    value = "${aws_instance.swarm_worker.*.private_ip}"
}
