resource "aws_security_group" "aloha_worker_node_sg" {
  name        = "aloha-worker-node-sg"
  description = "Security Group for EKS worker nodes"
  vpc_id      = aws_vpc.aloha_vpc.id

  tags = {
    Name = "aloha-worker-node-sg"
  }
}

# Allows inbound HTTPS traffic on port 443 from any IPv4 address.
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4_wn" {
  security_group_id            = aws_security_group.aloha_worker_node_sg.id
  referenced_security_group_id = aws_security_group.eks_alb_sg.id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

# Allows all outbound IPv4 traffic.
resource "aws_vpc_security_group_egress_rule" "all_external_ipv4_wn" {
  security_group_id = aws_security_group.aloha_worker_node_sg.id
  cidr_ipv4         = var.internet_cidr_ipv4
  ip_protocol       = "-1"
}

# Allows all outbound IPv6 traffic.
resource "aws_vpc_security_group_egress_rule" "all_external_ipv6_wn" {
  security_group_id = aws_security_group.aloha_worker_node_sg.id
  cidr_ipv6         = var.internet_cidr_ipv6
  ip_protocol       = "-1"
}
