Setup AWS ECS (Fargate) with Terraform

##Create AWS ECR 
1. Create a new repository to host the Docker images
2. Note down the instructions to complete the `aws ecr login ...` and `docker push ...` commands.

##Webserver App

Based on `nginx`, this Docker image, when run as a container, will output
the host name of the container and the app version.

1. Goto ../hostnameapp
2. Build the Docker image, like, 
docker build --rm -f Dockerfile -t <custom-tag> .
3. Tag the newly built image, like,
docker tag <custom-tag> <ecr-repo-path>:<custom-tag>
4. Run, aws ecr login ...
5. Push the Docker image, that was tagged in step 3, like,
docker push <ecr-repo-path>:<custom-tag>

##Setup ECS Cluster
1. Fill in the blank fields in `terraform.tfvars` with appropriate values.

###terraform.tfvars

aws_region = "your-region-name"

vpc_id     = "your-vpc-id"

subnet_ids = "your-subnet-id1,your-subnet-id2"

2. Run, `terraform init`

3. Run, `terraform plan -out=ecs-fargate.plan -state=terraform.tfstate`

When prompted, provide inputs for the following variables.

#### Name of the ECS cluster

#### Name that should be assigned when starting the container

#### Image source <ecr-repo-url>

4. Review the plan output, and when ready, spin up the cluster, like,

`terraform apply ecs-fargate.plan`

##What will be ready to use in the cluster?
### ECS cluster

### 