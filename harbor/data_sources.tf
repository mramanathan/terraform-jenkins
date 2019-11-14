data "terraform_remote_state" "vpc" {
    backend = "s3"

    config  = {
        bucket = "aws-cloud-deploy-tfstate"
        key    = "layer1/infrastructure.tfstate"
        region = "${var.region}"
    }
}