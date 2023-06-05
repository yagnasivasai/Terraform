variable "az" {
  default = "us-east-1"
}

variable "instancetype" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-083654bd07b5da81d"
}

variable "subnet_id" {}

variable "securitygroup" {}
