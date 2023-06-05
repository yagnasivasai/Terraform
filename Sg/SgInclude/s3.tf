resource "aws_s3_bucket" "scripts" {
  bucket = "UniquenessScripter"
  acl    = "private"
}
resource "aws_s3_bucket_object" "scripts" {
  bucket = aws_s3_bucket.scripts.id
  key    = "ubuntu.sh"
  source = "config/ubuntu.sh"
  etag   = filemd5("config/ubuntu.sh")
}
resource "aws_s3_bucket_object" "scripts" {
  bucket   = aws_s3_bucket.scripts.id
  for_each = fileset("config/", "*")
  key      = each.value
  source   = "config/${each.value}"
  etag     = filemd5("config/${each.value}")
}

