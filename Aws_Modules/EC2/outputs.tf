output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "security_group_id" {
  description = "ID of the Security Group"
  value       = aws_security_group.ec2_sg.id

}


output "iam_role_arn" {
  description = "ARN of the IAM Role assigned to the EC2 instance"
  value       = aws_iam_role.ec2_role.arn
}
