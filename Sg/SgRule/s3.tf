resource "aws_s3_bucket" "mybucket" {
  bucket = "9494972917scripts"
  acl    = "private"
}
resource "aws_s3_bucket_object" "singleobject" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "ubuntu.sh"
  source = "D:\\Real\\Terraform\\Shell-Scripts\\ubuntu.sh"
  etag   = filemd5("D:\\Real\\Terraform\\Shell-Scripts\\ubuntu.sh")
}
resource "aws_s3_bucket_object" "multipleobjects" {
  bucket   = aws_s3_bucket.mybucket.id
  for_each = fileset("D:\\Real\\Terraform\\Shell-Scripts", "*")
  key      = each.value
  source   = "D:\\Real\\Terraform\\Shell-Scripts\\${each.value}"
  etag     = filemd5("D:\\Real\\Terraform\\Shell-Scripts\\${each.value}")
}
