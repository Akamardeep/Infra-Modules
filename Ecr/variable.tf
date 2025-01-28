variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Indicates whether image tags are mutable (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Whether to enable encryption using AWS KMS"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use for encryption (required if encryption is enabled)"
  type        = string
  default     = null
}

variable "lifecycle_policy" {
  description = "JSON policy for managing the lifecycle of images"
  type        = string
  default     = null
}

variable "repository_policy" {
  description = "JSON policy for managing access to the repository"
  type        = string
  default     = null
}
