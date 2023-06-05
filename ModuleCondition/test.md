data "aws_s3_bucket_object" "secret_key" {
bucket = "yegnasivasai-bash-scripts"
key = "script.sh"
}
provisioner "file" {
content = data.aws_s3_bucket_object.secret_key.body
destination = /tmp/script.sh
}

resource "aws_s3_bucket" "mybucket" {
bucket = "yegnasivasai-bash-scripts"
acl = "private"
}
resource "aws_s3_bucket_object" "singleobject" {
bucket = aws_s3_bucket.mybucket.bucket
key = "script.sh"
source = "D:\\Terraform_Test\\script.sh"
etag = filemd5("D:\\Terraform_Test\\script.sh")
}
resource "null_resource" "test" {
connection {
user = "ubuntu"
type = "ssh"
host = aws_instance.ec2test.public_ip
private_key = file("D:\\Terraform_Test\\test.pem")

}
<< EOF
#! /bin/bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws s3 cp s3://yegnasivasai-bash-scripts ./tmp/scr --recursive
chmod +x ./tmp/tmp/scr/script.sh
./tmp/tmp/scr/script.sh
EOF

provisioner "file" {
source = "D:\\Terraform_Test\\script.sh"
destination = "/tmp/script.sh"
}

provisioner "remote-exec" {
inline = [
"chmod +x /tmp/script.sh",
"/tmp/script.sh args",
]
}
