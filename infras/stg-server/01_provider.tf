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
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
