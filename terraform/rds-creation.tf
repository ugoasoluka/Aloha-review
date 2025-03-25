# Get the secret by name
data "aws_secretsmanager_secret" "docdb_password_secret" {
  name = "tasky-app-secrets"
}

# Get the latest version of the secret value
data "aws_secretsmanager_secret_version" "docdb_password" {
  secret_id = data.aws_secretsmanager_secret.docdb_password_secret.id
}

# Decode the JSON secret into a map
locals {
  docdb_secret_json = jsondecode(data.aws_secretsmanager_secret_version.docdb_password.secret_string)
}

# Create the subnet group for DocumentDB
resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  tags = {
    Name = "Aloha DocDB Subnet Group"
  }
}

# Create the DocumentDB cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier     = "aloha-docdb"
  master_username        = var.db_name
  master_password        = local.docdb_secret_json["DocDBMasterPassword"]
  db_subnet_group_name   = aws_docdb_subnet_group.docdb_subnet_group.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  engine_version         = "4.0.0"
  skip_final_snapshot    = true

  tags = {
    Name = "${var.db_name}-docdb-cluster"
  }
}

# Create the DocumentDB instance
resource "aws_docdb_cluster_instance" "docdb_instance" {
  identifier         = "aloha-docdb-instance-0"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"

  tags = {
    Name = "${var.db_name}-docdb-instance-0"
  }
}

# Create a security group to allow EKS access to DocDB
resource "aws_security_group" "docdb_sg" {
  name        = "${var.db_name}-docdb-sg"
  description = "Allow access to DocumentDB from EKS nodes"
  vpc_id      = aws_vpc.aloha_vpc.id

  tags = {
    Name = "DocDB-Security-Group"
  }
}

# Allow inbound from EKS node security group (update SG ID as needed)
resource "aws_vpc_security_group_ingress_rule" "allow_eks_to_docdb" {
  security_group_id            = aws_security_group.docdb_sg.id
  referenced_security_group_id = "sg-04a8a8583fcdf69f6" # EKS node SG
  from_port                    = 27017
  to_port                      = 27017
  ip_protocol                  = "tcp"
}

# Allow all outbound traffic from DocDB
resource "aws_vpc_security_group_egress_rule" "docdb_allow_all_egress" {
  security_group_id = aws_security_group.docdb_sg.id
  cidr_ipv4         = var.internet_cidr_ipv4
  ip_protocol       = "-1"
}
