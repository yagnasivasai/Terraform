resource "random_uuid" "uuid" {}

resource "aws_s3_bucket" "mybucket" {
  bucket = "my-s3-bucket-${random_uuid.uuid.result}"
  acl    = "private"
}
resource "aws_s3_bucket_object" "singleobject" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "ubuntu.sh"
  source = "ubuntu.sh"
  etag   = filemd5("ubuntu.sh")
}
resource "aws_s3_bucket_object" "multipleobjects" {
  bucket   = aws_s3_bucket.mybucket.id
  for_each = fileset("scripts/", "*")
  key      = each.value
  source   = "scripts/${each.value}"
  etag     = filemd5("scripts/${each.value}")
}