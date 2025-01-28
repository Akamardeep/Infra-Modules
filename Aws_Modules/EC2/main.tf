provider "aws" {
  region = var.region
}

# Generate a new key pair using TLS
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS Key Pair using the generated public key
resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh

  tags = {
    Name = "MyKeyPair"
  }
}

# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/${var.key_name}.pem"  # Save private key as <key_name>.pem
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
# IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = "${var.project}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Name = "${var.project}-ec2-role"
  }
}

# IAM Policy for EC2 Role
resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.project}-ec2-policy"
  description = "Policy to allow EC2 instance to access specific resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.iam_policy_actions,  # Allow customizable actions
        Effect   = "Allow",
        Resource = var.iam_policy_resources
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Instance Profile for the IAM Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Assume Role Policy Document
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_key_pair.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] 
  associate_public_ip_address = var.associate_public_ip
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "${var.project}-ec2-instance"
  }

  root_block_device {
    volume_size = var.root_volume_size
  }

  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = var.ebs_volume_size
    delete_on_termination = true
  }
}
