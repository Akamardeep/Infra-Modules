provider "aws" {
  region = var.region
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address

  tags = var.tags
}

# Generate a new SSH private-public key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the key pair in AWS using the generated public key
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.example.public_key_openssh  # Use the generated public key

  tags = {
    Name = "MyKeyPair"
  }
}

# Optionally, store the private key on your local machine
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/my-key-pair.pem"  # Save private key to a file
}
