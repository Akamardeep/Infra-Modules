resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = var.enable_encryption ? "KMS" : "AES256"
    kms_key         = var.enable_encryption ? var.kms_key_arn : null
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository      = aws_ecr_repository.this.name
  policy          = var.lifecycle_policy
  depends_on      = [aws_ecr_repository.this]
}

resource "aws_ecr_repository_policy" "this" {
  repository      = aws_ecr_repository.this.name
  policy          = var.repository_policy
  depends_on      = [aws_ecr_repository.this]
}
