output "vpc_id" {
  description = "Main VPC Id"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public Subnet Id"
  value       = aws_subnet.public_sub.id
}

output "web_tier_subnet_id" {
  description = "Web Tier Subnet Id"
  value       = [aws_subnet.web_sub.*.id]
}

output "app_tier_subnet_id" {
  description = "App Tier Subnet Id"
  value       = [aws_subnet.app_sub.*.id]
}

output "data_tier_subnet_id" {
  description = "Data Tier Subnet Id"
  value       = [aws_subnet.data_sub.*.id]
}

output "EIP_NAT" {
  description = "Elastic IP for the NAT Gateway"
  value       = aws_eip.eip.id
}

output "rds_subnet_group" {
  description = "RDS Subnet Group"
  value       = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_connection_string" {
  description = "The RDS connection String"
  value       = aws_db_instance.my_test_rds.endpoint
}

output "ec2_instance_id" {
  description = "The EC2 instance ids"
  value       = [aws_instance.EC2_Web_Server.*.id]
}

output "ec2_instance_public_ip" {
  description = "The EC2 instances"
  value       = [aws_instance.EC2_Web_Server.*.public_ip]
}

output "ALB_DNS" {
  description = "The ALB DNS Name"
  value       = aws_lb.web_tier_alb.dns_name
}