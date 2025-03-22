#Creates ECR repository for Docker Image
resource "aws_ecr_repository" "aloha_repo" {
  name                 = "${var.ecr_repo_name}-repo"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
