resource "aws_s3_bucket" "s3_bucket" {
  bucket = format("ztr-bucket-%s-%s", var.region, var.bucket_name)
  bucket_namespace = "global"

  tags = {
    Name        = var.name_tags
  }
}
resource "aws_s3_bucket_public_access_block" "block-public-access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}