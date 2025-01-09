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
