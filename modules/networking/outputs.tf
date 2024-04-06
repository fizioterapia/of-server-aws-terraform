output "security_group_id" {
  value = aws_security_group.of_access.id
}

output "public_subnet_id" {
  value = aws_subnet.of_public.id
}