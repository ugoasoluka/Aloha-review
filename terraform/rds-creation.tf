# Creates a DB subnet group for the RDS instance.
resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  tags = {
    Name = "Aloha DB subnet group"
  }
}

resource "aws_db_instance" "mysql_instance" {
  identifier                  = "aloha"
  allocated_storage           = 20
  max_allocated_storage       = 100
  db_name                     = var.db_name
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  username                    = var.db_name
  manage_master_user_password = true
  publicly_accessible         = false
  multi_az                    = true
  #   availability_zone           = "${var.aws_region}a"
  storage_encrypted       = false
  deletion_protection     = false
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_security_group.id]
  backup_retention_period = 1
  port                    = var.db_port
  tags = {
    Name = "${var.db_name}-db"
  }
}

# Creates a security group for the RDS instance.
resource "aws_security_group" "rds_security_group" {
  name        = "${var.db_name}-SG"
  description = "Security Group for RDS"
  vpc_id      = aws_vpc.aloha_vpc.id

  tags = {
    Name = "RDS-Security-Group"
  }
}

# Allows inbound traffic on port 3306 (mySQL).
resource "aws_vpc_security_group_ingress_rule" "allow_from_eks_nodes" {
  security_group_id            = aws_security_group.rds_security_group.id
  referenced_security_group_id = aws_security_group.aloha_worker_node_sg.id
  from_port                    = 3306
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

# Allows all outbound traffic from the RDS instance.
resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = var.internet_cidr_ipv4
  ip_protocol       = "-1"
}
