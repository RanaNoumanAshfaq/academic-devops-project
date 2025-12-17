resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app_bucket" {
  # Buckets must have globally unique names, so we add a random suffix
  bucket = "${var.project_name}-assets-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "Academic"
  }
}

# SECURITY: Block all public access by default (Best Practice)
resource "aws_s3_bucket_public_access_block" "app_bucket_acl" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning: Keeps history of files (Good for recovery)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.app_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}