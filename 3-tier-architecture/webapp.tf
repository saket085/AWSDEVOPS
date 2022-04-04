#Beginning of the template

# Create http security group for webservers
resource "aws_security_group" "web_alb_sec_grp_http" {
  name        = "incoming_alb_http"
  description = "allow inbound incoming http traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "ALB Security Group for ${aws_subnet.web_sub.0.id} and ${aws_subnet.web_sub.1.id}"
    Project = var.project_name
  }
}

# Create EC2 security group to accept traffic only from the ALB
resource "aws_security_group" "web_ec2_sec_grp_http" {
  name        = "incoming_ec2_http"
  description = "allow inbound incoming http traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.web_alb_sec_grp_http.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "EC2 Security Group for ${aws_subnet.web_sub.0.id} and ${aws_subnet.web_sub.1.id}"
    Project = var.project_name
  }
}

# Create ssh security group for webservers
resource "aws_security_group" "web_sec_grp_ssh" {
  name        = "incoming_ssh"
  description = "allow inbound incoming ssh traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SSH Security Group for ${aws_subnet.web_sub.0.id} and ${aws_subnet.web_sub.1.id}"
    Project = var.project_name
  }
}

# Create EC2 instances for Web Tier
resource "aws_instance" "EC2_Web_Server" {
  count                  = length(var.web_subnets_cidr_blocks)
  ami                    = var.web_ami_id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [aws_security_group.web_ec2_sec_grp_http.id, aws_security_group.web_sec_grp_ssh.id]
  subnet_id              = element(aws_subnet.web_sub.*.id, count.index)

  tags = {
    Name    = "The Web Servers"
    Project = var.project_name
  }
}

#Create the Application Load Balancer
resource "aws_lb" "web_tier_alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb_sec_grp_http.id]
  subnets            = [for subnet in aws_subnet.web_sub : subnet.id]

  tags = {
    Name    = "ALB for ${aws_subnet.web_sub.0.id} and ${aws_subnet.web_sub.1.id}"
    Project = var.project_name
  }
}

# Create the ALB Target Group
resource "aws_lb_target_group" "ALB_TG" {
  name     = var.alb_tg_name
  port     = var.alb_tg_port
  protocol = var.alb_tg_protocol
  vpc_id   = aws_vpc.main.id

  tags = {
    Name    = "ALB Target Group for ${aws_subnet.web_sub.0.id} and ${aws_subnet.web_sub.1.id}"
    Project = var.project_name
  }
}

# Create ALB's Listeners
resource "aws_lb_listener" "Web_ALB_Lstnr" {
  load_balancer_arn = aws_lb.web_tier_alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    target_group_arn = aws_lb_target_group.ALB_TG.arn
    type             = "forward"
  }

  tags = {
    Name    = "ALB Listeners for ${aws_subnet.web_sub.0.id} and ${aws_subnet.web_sub.1.id}"
    Project = var.project_name
  }
}

# Create Listener Rules
resource "aws_lb_listener_rule" "web_alb_listener_rule_allow_all" {
  listener_arn = aws_lb_listener.Web_ALB_Lstnr.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB_TG.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}