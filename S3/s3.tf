provider "aws" {
  region = "us-east-1"

}

resource "aws_s3_bucket" "mybucket" {
  bucket = "9494972917qw"
  acl    = "private"
}
resource "aws_s3_bucket_object" "singleobject" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "ubuntu.sh"
  source = "D:\\Real\\Terraform\\config\\ubuntu.sh"
  etag   = filemd5("D:\\Real\\Terraform\\config\\ubuntu.sh")
}
resource "aws_s3_bucket_object" "multipleobjects" {
  bucket   = aws_s3_bucket.mybucket.id
  for_each = fileset("D:\\Real\\Terraform\\config", "*")
  key      = each.value
  source   = "D:\\Real\\Terraform\\config\\${each.value}"
  etag     = filemd5("D:\\Real\\Terraform\\config\\${each.value}")
}
