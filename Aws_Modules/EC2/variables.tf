variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name for tagging resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for the EC2 instance"
  type        = string
}

variable "public_key" {
  description = "Public key for SSH access"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_cidr_blocks" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "associate_public_ip" {
  description = "Associate a public IP with the EC2 instance"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Size of the root EBS volume (in GB)"
  type        = number
  default     = 8
}

variable "ebs_volume_size" {
  description = "Size of the additional EBS volume (in GB)"
  type        = number
  default     = 20
}
