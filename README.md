## Objective

You want to have a private development environment to play around with Docker CE or learn Docker in AWS ECS. The scripts in the various folders facilitate creation of couple of EC2 instances in AWS. As soon as the instances are up and running, Ansible playbook can be executed to provision Docker CE or setup the Swarm cluster or AWS ECS.

## Pre-requisites

- AWS account -- if you do not want to incur charges, then go with free tier.
- AWS account credentials, preferably, non-root user.

In the control machine, setup AWS credentials as per this procedure.

To stand up the infrastructure (to run terraform commands), in the control machine,

- Terraform v0.12.16 and above

### EC2 instances will be configured as below,

- OS : Ubuntu 18.04 AMI (amd64)
- `hvm` as virtualization engine
- Permit SSH access from the subnet that's specified via the `local_ip_address` variable


### ec2_ubuntu_docker
* Contains Terraform scripts to provision fresh EC2 instances
* Post provision, Ansible playbook `docker_setup.yml` can be used to install, configure and setup Docker CE.


### ec2_ubuntu_docker_swarm
* Contains Terraform scripts to provision fresh EC2 instances
* Post provision, Ansible playbook `deploy_swarm.yml` can be used to setup Docker CE on all the nodes, and setup the Swarm cluster.
* Default config of the cluster : One manager and two worker nodes.


### ecs_webserver
`TBU`