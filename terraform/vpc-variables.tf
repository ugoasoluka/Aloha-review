# Variables for VPC and subnet CIDR blocks.

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "Public Subnet A CIDR"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "Public Subnet B CIDR"
  default     = "10.0.2.0/24"
}

variable "availability_zone_a" {
  type        = string
  description = "Availability zone A"
  default     = "us-east-1a"
}

variable "availability_zone_b" {
  type        = string
  description = "Availability zone B"
  default     = "us-east-1b"
}

variable "private_subnet_cidr_a" {
  type        = string
  description = "Private Subnet A CIDR"
  default     = "10.0.101.0/24"
}

variable "private_subnet_cidr_b" {
  type        = string
  description = "Private Subnet B CIDR"
  default     = "10.0.102.0/24"
}

# Variables for internet traffic CIDR blocks.
variable "internet_cidr_ipv4" {
  description = "CIDR block for IPv4 internet traffic"
  default     = "0.0.0.0/0"
}

variable "internet_cidr_ipv6" {
  description = "CIDR block for IPv6 internet traffic"
  default     = "::/0"
}
