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
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"  # Specify the name for the key pair
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your local public key

  tags = {
    Name = "MyKeyPair"
  }
}
