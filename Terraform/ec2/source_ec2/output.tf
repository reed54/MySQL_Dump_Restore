output "ec2-source_private_dns" {
  value = aws_instance.ec2-source.private_dns
}

output "ec2-source_public_dns" {
  value = aws_instance.ec2-source.public_dns
}

output "ec2-source_IP" {
  value = aws_instance.ec2-source.public_ip
}