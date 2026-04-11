# EventsLK Infrastructure with Dynamic Variables
provider "aws" {
  region = var.aws_region
}

# 1. Network: VPC
resource "aws_vpc" "eventslk_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "eventslk-vpc" }
}

# 2. Network: Internet Gateway
resource "aws_internet_gateway" "eventslk_igw" {
  vpc_id = aws_vpc.eventslk_vpc.id
  tags   = { Name = "eventslk-igw" }
}

# 3. Network: Public Subnet
resource "aws_subnet" "eventslk_public_subnet" {
  vpc_id                  = aws_vpc.eventslk_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a" # Dynamic availability zone
  tags                    = { Name = "eventslk-public-subnet" }
}

# 4. Network: Route Table & Association
resource "aws_route_table" "eventslk_rt" {
  vpc_id = aws_vpc.eventslk_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eventslk_igw.id
  }
}

resource "aws_route_table_association" "eventslk_rta" {
  subnet_id      = aws_subnet.eventslk_public_subnet.id
  route_table_id = aws_route_table.eventslk_rt.id
}

# 5. Security: Combined Security Group
resource "aws_security_group" "eventslk_sg" {
  name        = "eventslk-sg"
  vpc_id      = aws_vpc.eventslk_vpc.id
  description = "Security group for K8s, Spring Boot, Nginx and MySQL"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ArgoCD UI 
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 6. Compute: Master Node
resource "aws_instance" "eventslk_master" {
  ami                    = var.ami_val
  instance_type          = var.master_instance_type # Using variable
  subnet_id              = aws_subnet.eventslk_public_subnet.id # Dynamic link
  vpc_security_group_ids = [aws_security_group.eventslk_sg.id] # Dynamic link
  key_name               = var.key_name_val

  tags = { Name = "eventslk-master" }
}

# 7. Compute: Worker Node
resource "aws_instance" "eventslk_worker" {
  count                  =2
  ami                    = var.ami_val
  instance_type          = var.worker_instance_type # Using variable
  subnet_id              = aws_subnet.eventslk_public_subnet.id # Dynamic link
  vpc_security_group_ids = [aws_security_group.eventslk_sg.id] # Dynamic link
  key_name               = var.key_name_val

  tags = { Name = "eventslk-worker" }
}