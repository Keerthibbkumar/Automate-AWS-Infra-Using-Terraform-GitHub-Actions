output "aws_loadbalaner_dns" {
  value = aws_lb.app_lb.dns_name
}

output "aws_instace" {
  value = aws_instance.name[*].public_ip
}