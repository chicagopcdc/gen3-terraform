module "bucket" {
  source            = "../../../../tf_files/aws/modules/s3-bucket"
  bucket_name       = "${var.vpc_name}-${var.bucket_suffix}-bucket"
  environment       = var.vpc_name
  cloud_trail_count = 0
  manage_lifecycle  = var.manage_lifecycle
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = module.bucket.bucket_name

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = module.bucket.bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  count = !var.manage_lifecycle ? 1 : 0
  bucket = module.bucket.bucket_name

  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id     = "noncurrent-version-expiration"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
  count  = length(var.allowed_origins) > 0 ? 1 : 0
  bucket = module.bucket.bucket_name

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = var.allowed_origins
    expose_headers  = ["Access-Control-Allow-Origin", "ETag", "x-csrf-token", "Content-Security-Policy"]
    max_age_seconds = 3000
  }
}
