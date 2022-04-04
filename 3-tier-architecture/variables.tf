variable "region" {
  description = "AWS region to create VPC"
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "172.16.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "3 Tier - Network"
}

variable "project_name" {
  description = "Project Name"
  default     = "test-3-tier"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  default     = "eu-west-2a"
}

variable "public_subnets_cidr_ranges" {
  description = "CIDR blocks of subnets in public layer for web apps"
  default     = "172.16.1.0/24"
}

variable "web_subnets_cidr_blocks" {
  description = "CIDR blocks of subnets in web tier"
  default     = ["172.16.2.0/24", "172.16.3.0/24"]
}

variable "app_subnets_cidr_blocks" {
  description = "CIDR blocks of subnets in app tier"
  default     = ["172.16.4.0/24", "172.16.5.0/24"]
}

variable "data_subnets_cidr_blocks" {
  description = "CIDR blocks of subnets in data tier"
  default     = ["172.16.6.0/24", "172.16.7.0/24"]
}

variable "rds_subnet_group_name" {
  description = "Name of the RDS Subnet Group"
  default     = "my_test_rds"
}

variable "rds_allocated_storage" {
  description = "Storage for the RDS Instance"
  default     = 5
}

variable "rds_storage_type" {
  description = "Storage Type for the RDS Instance"
  default     = "gp2"
}

variable "rds_engine" {
  description = "Database Engine Type for the RDS"
  default     = "mysql"
}

variable "rds_instance_class" {
  description = "Instance Class for the RDS"
  default     = "db.t2.micro"
}

variable "rds_name" {
  description = "Name of the RDS DB"
  default     = "my_test_sql_rds"
}

variable "rds_username" {
  description = "Username to connect to the database"
  default     = "admin_rds"
  sensitive   = true
}

variable "rds_password" {
  description = "Password to connect to the database"
  default     = "testsql_admin007"
  sensitive   = true
}

variable "web_ami_id" {
  description = "The AMI Id to launch the web server instances."
  default     = "ami-0a4b5c4a6ada12bb0"
}

variable "web_instance_type" {
  description = "The instance type for the web servers"
  default     = "t2.micro"
}

variable "alb_name" {
  description = "The name of the ALB"
  default     = "Web-ALB"
}

variable "alb_tg_name" {
  description = "Web Server ALB Target Group"
  default     = "Web-ALB-TG"
}

variable "alb_tg_port" {
  description = "Web Server ALB Port"
  default     = "80"
}

variable "alb_tg_protocol" {
  description = "Front End ALB Protocol"
  default     = "HTTP"
}

variable "listener_port" {
  description = "The listener for the front end ALB"
  default     = "80"
}

variable "listener_protocol" {
  description = "The listener protocol for the front end ALB"
  default     = "HTTP"
}