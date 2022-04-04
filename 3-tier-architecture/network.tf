# Beginning of the template
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

# Declare the data resource AZs
data "aws_availability_zones" "available" {}

# The VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name    = var.vpc_name
    Project = var.project_name
  }
}

# The Public Subnet - to host NAT Gatweway etc.
resource "aws_subnet" "public_sub" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zone
  cidr_block              = var.public_subnets_cidr_ranges
  map_public_ip_on_launch = true

  tags = {
    Name    = "Public Subnet"
    Project = var.project_name
  }

}

# The Private Subnet - Web Tier - At least 2 subnets for Web Tier ALB
resource "aws_subnet" "web_sub" {
  count                   = length(var.web_subnets_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnets_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "Web Subnet-Public"
    Project = var.project_name
  }
}

# The Private Subnet - App Tier - At least 2 subnets for Private Tier ALB
resource "aws_subnet" "app_sub" {
  count             = length(var.app_subnets_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnets_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name    = "App Subnet-Private"
    Project = var.project_name
  }
}

# The Private Subnet - Data Tier - At least 2 subnets for a data tier 
resource "aws_subnet" "data_sub" {
  count             = length(var.data_subnets_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.data_subnets_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name    = "Data Subnet-Private"
    Project = var.project_name
  }
}

# The Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "Internet Gateway for ${var.vpc_name}"
    Project = var.project_name
  }
}

# Custom Route Table, to override the default behaviour
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "Public Route Table"
    Project = var.project_name
  }
}

# Associate the public subnet to its Route Table
resource "aws_route_table_association" "pub_rt_associate" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_route_table.public_rt.id
}

# EIP in the VPC to attach to the NAT Gateway
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name    = "NAT Gateway EIP"
    Project = var.project_name
  }
}

# NAT Gateway - For private subnets to access the internet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_sub.id

  tags = {
    Name    = "NAT Gateway for ${var.vpc_name}"
    Project = var.project_name
  }
}

# Route Tables for the Web Tier - Public
resource "aws_route_table" "web_tier" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "Web Tier RT"
    Project = var.project_name
  }
}

# Associate the Web tier to its Route Table
resource "aws_route_table_association" "web_rt_associate" {
  count          = length(var.web_subnets_cidr_blocks)
  subnet_id      = element(aws_subnet.web_sub.*.id, count.index)
  route_table_id = aws_route_table.web_tier.id
}

# Route Tables for the App Tier - Private
resource "aws_route_table" "app_tier" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name    = "App Tier RT"
    Project = var.project_name
  }
}

# Associate the App tier to its Route Table
resource "aws_route_table_association" "app_rt_associate_data" {
  count          = length(var.app_subnets_cidr_blocks)
  subnet_id      = element(aws_subnet.app_sub.*.id, count.index)
  route_table_id = aws_route_table.app_tier.id
}

# Create the route table for the Data Tier
resource "aws_route_table" "data_tier" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name    = "Data Tier RT"
    Project = var.project_name
  }
}

# Associate the Data Tier to its Route Table
resource "aws_route_table_association" "data_tier" {
  count          = length(var.data_subnets_cidr_blocks)
  subnet_id      = element(aws_subnet.data_sub.*.id, count.index)
  route_table_id = aws_route_table.data_tier.id
}