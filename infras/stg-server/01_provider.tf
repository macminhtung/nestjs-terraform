# PROVIDER
provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      "Environment" = "${var.stage}"
      "Owner"   = "zigvy"
      "Project" = "${var.project_name}"
    }
  }
}

# INITIALIZE TERRAFORM REMOTE STATE
terraform {
  backend "s3" {
    bucket = "datalake-stg-server-terraform"
    key    = "terraform/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
