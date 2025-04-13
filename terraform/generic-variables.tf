# Generic Variables for the project

# Variable for the AWS region
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

# Variable for the database name.
variable "db_name" {
  description = "database name"
  type        = string
  default     = "tasky_database"
}

# Variable for the database port.
variable "db_port" {
  description = "database port"
  type        = string
  default     = "3306"
}

# Variable to store the ECR Repo Name
variable "ecr_repo_name" {
  description = "ECR Repo Name"
  default     = "tasky-app"
}
# Variables related to the EKS cluster.
variable "eks_cluster_name" {
  type    = string
  default = "tasky-cluster"
}
