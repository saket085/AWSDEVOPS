# Beginning of the template

# Create the RDS subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = [for subnet in aws_subnet.data_sub : subnet.id]

  tags = {
    Name    = "RDS Subnet Group"
    Project = var.project_name
  }
}

resource "aws_security_group" "rds" {
  name        = "RDS_security_group"
  description = "Example RDS MySQL server"
  vpc_id      = aws_vpc.main.id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb_sec_grp_http.id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "rds-security-group"
    Project = var.project_name
  }
}

# Create RDS instance 
resource "aws_db_instance" "my_test_rds" {
  allocated_storage      = var.rds_allocated_storage
  storage_type           = var.rds_storage_type
  engine                 = var.rds_engine
  instance_class         = var.rds_instance_class
  name                   = var.rds_name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = var.rds_subnet_group_name
  # Ensure to create RDS Instance only post the creation of the RDS Subnet Group
  depends_on          = [aws_db_subnet_group.rds_subnet_group]
  skip_final_snapshot = true

  tags = {
    Name    = "My Test SQL Server"
    Project = var.project_name
  }
}