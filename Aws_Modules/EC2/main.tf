provider "aws" {
  region = var.region
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-ec2-sg"
  }
}

# Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = var.subnet_id
  security_group_ids     = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name = "${var.project}-ec2-instance"
  }

  # Optional EBS volume attachment
  root_block_device {
    volume_size = var.root_volume_size
  }

  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = var.ebs_volume_size
    delete_on_termination = true
  }
}
