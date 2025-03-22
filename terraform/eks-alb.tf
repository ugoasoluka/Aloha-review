resource "aws_security_group" "eks_alb_sg" {
  name        = "eks-alb-sg"
  description = "alb-ingress-sg"
  vpc_id      = aws_vpc.aloha_vpc.id

  tags = {
    Name = "eks-alb-sg"
  }
}

# Allows inbound HTTPS traffic on port 443 from any IPv4 address.
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4_alb" {
  security_group_id = aws_security_group.eks_alb_sg.id
  cidr_ipv4         = var.internet_cidr_ipv4
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Allows inbound HTTPS traffic on port 443 from any IPv6 address.
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv6_alb" {
  security_group_id = aws_security_group.eks_alb_sg.id
  cidr_ipv6         = var.internet_cidr_ipv6
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Allows inbound HTTPS traffic on port 80 from any IPv4 address.
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_alb" {
  security_group_id = aws_security_group.eks_alb_sg.id
  cidr_ipv4         = var.internet_cidr_ipv4
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allows inbound HTTPS traffic on port 80 from any IPv6 address.
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6_alb" {
  security_group_id = aws_security_group.eks_alb_sg.id
  cidr_ipv6         = var.internet_cidr_ipv6
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allows all outbound IPv4 traffic.
resource "aws_vpc_security_group_egress_rule" "all_external_ipv4_alb" {
  security_group_id = aws_security_group.eks_alb_sg.id
  cidr_ipv4         = var.internet_cidr_ipv4
  ip_protocol       = "-1"
}

# Allows all outbound IPv6 traffic.
resource "aws_vpc_security_group_egress_rule" "all_external_ipv6_alb" {
  security_group_id = aws_security_group.eks_alb_sg.id
  cidr_ipv6         = var.internet_cidr_ipv6
  ip_protocol       = "-1"
}
