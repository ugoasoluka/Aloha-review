###############################################
# VPC
###############################################
resource "aws_vpc" "aloha_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "aloha-VPC"
  }
}

###############################################
# Public Subnets, Internet Gateway, and Public Route Table
###############################################
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.aloha_vpc.id
  cidr_block              = var.public_subnet_cidr_a
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true

  tags = {
    Name = "aloha-public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.aloha_vpc.id
  cidr_block              = var.public_subnet_cidr_b
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name = "aloha-public-subnet-b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.aloha_vpc.id

  tags = {
    Name = "aloha-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.aloha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "aloha-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}


###############################################
# Private Subnets
###############################################
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.aloha_vpc.id
  cidr_block        = var.private_subnet_cidr_a
  availability_zone = var.availability_zone_a

  tags = {
    Name = "aloha-private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.aloha_vpc.id
  cidr_block        = var.private_subnet_cidr_b
  availability_zone = var.availability_zone_b

  tags = {
    Name = "aloha-private-subnet-b"
  }
}

###############################################
# NAT Gateways (One per Availability Zone)
###############################################

# NAT Gateway for AZ A
resource "aws_eip" "elastic_ip_nat_gw_a" {
  domain = "vpc"
  tags = {
    Name = "aloha-nat-eip-a"
  }
}

resource "aws_nat_gateway" "nat_gw_a" {
  allocation_id = aws_eip.elastic_ip_nat_gw_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "aloha-nat-gateway-a"
  }

  depends_on = [aws_internet_gateway.gw, aws_eip.elastic_ip_nat_gw_a]
}

# NAT Gateway for AZ B
resource "aws_eip" "elastic_ip_nat_gw_b" {
  domain = "vpc"
  tags = {
    Name = "aloha-nat-eip-b"
  }
}

resource "aws_nat_gateway" "nat_gw_b" {
  allocation_id = aws_eip.elastic_ip_nat_gw_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "aloha-nat-gateway-b"
  }

  depends_on = [aws_internet_gateway.gw, aws_eip.elastic_ip_nat_gw_b]
}

###############################################
# Private Route Tables (One per Private Subnet AZ)
###############################################
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.aloha_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_a.id
  }

  tags = {
    Name = "aloha-private-route-table-a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.aloha_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_b.id
  }

  tags = {
    Name = "aloha-private-route-table-b"
  }
}

###############################################
# Private Subnet Route Table Associations
###############################################
resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}

# ###############################################
# # EKS security group and module creation
# ###############################################

# module "sgs" {
#   source = "./eks-sg"
#   vpc_id = aws_vpc.aloha_vpc.id
# }

# module "eks" {
#   source     = "./eks"
#   subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
#   sg_ids     = module.sgs.security_group_public
# }
