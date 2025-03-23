
# Output the ID of public subnet a.
output "public_subnet_a" {
  description = "Public subnet a ID"
  value       = aws_subnet.public_subnet_a.id
}

# Output the ID of public subnet b.
output "public_subnet_b" {
  description = "Public subnet b ID"
  value       = aws_subnet.public_subnet_b.id

}

# Output the ID of private subnet a.
output "private_subnet_a" {
  description = "Private subnet a ID"
  value       = aws_subnet.private_subnet_a.id

}

# Output the ID of private subnet b.
output "private_subnet_b" {
  description = "Private subnet IDs"
  value       = aws_subnet.private_subnet_b.id
}

