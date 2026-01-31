terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------
# AWS Provider
# ---------------------------
provider "aws" {
  region = "us-east-1"
}

# ---------------------------
# SSH Key Pair
# ---------------------------
resource "aws_key_pair" "devops_key" {
  key_name   = "ai-devops-key"
  public_key = file("~/.ssh/ai-devops-key.pub")
}

# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "devops_sg" {
  name        = "ai-devops-sg"
  description = "Allow SSH and Flask app access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask App"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# EC2 Instance (Ubuntu + Docker)
# ---------------------------
resource "aws_instance" "devops_ec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 LTS (us-east-1)
  instance_type          = "t3.micro"              # UPDATED
  key_name               = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              EOF

  tags = {
    Name        = "ai-devops-ubuntu"
    Project     = "ai-autonomous-devops-agent"
    Environment = "dev"
  }
}
