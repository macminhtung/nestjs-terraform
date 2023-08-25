# ECR REPOSITORY [hrforte-repository]: Initialize ecr repository
resource "aws_ecr_repository" "hrforte-repository" {
  name                 = "${var.project_name}"
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "${var.project_name} API ECR Repo"
  }
  force_delete = true
}