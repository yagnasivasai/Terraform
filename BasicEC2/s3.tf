resource "aws_s3_bucket" "mybucket" {
  bucket = "9494972917scripts"
  acl    = "private"
}
resource "aws_s3_bucket_object" "singleobject" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "ubuntu.sh"
  source = "Shell-Scripts/ubuntu.sh"
  etag   = filemd5("DShell-Scripts/ubuntu.sh")
}
resource "aws_s3_bucket_object" "multipleobjects" {
  bucket   = aws_s3_bucket.mybucket.id
  for_each = fileset("Shell-Scripts/", "*")
  key      = each.value
  source   = "Shell-Scripts/${each.value}"
  etag     = filemd5("Shell-Scripts/${each.value}")
}