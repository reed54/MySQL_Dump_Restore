output "ec2-target_private_dns" {
  value = aws_instance.ec2-target.private_dns
}

output "ec2-target_public_dns" {
  value = aws_instance.ec2-target.public_dns
}

output "ec2-target_IP" {
  value = aws_instance.ec2-target.public_ip
}