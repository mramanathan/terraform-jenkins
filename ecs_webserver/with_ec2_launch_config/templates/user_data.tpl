#!/bin/bash

set -x
set -e

# Update pkg info
sudo yum update -y

# Join ECS cluster
sudo echo 'ECS_CLUSTER=${ecs_cluster}' > /etc/ecs/ecs.config

# Restart ECS agent service
sleep 5
sudo systemctl stop ecs
sleep 5
sudo systemctl start ecs