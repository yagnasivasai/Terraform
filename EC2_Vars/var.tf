variable "region" {
  default = "us-east-1"
}


variable "ami" {
  default = "ami-0b0af3577fe5e3532"
}


variable "instance_type" {
  default = "t2.micro"
}


variable "associate_public_ip_address" {
  default = "true"
}

variable "key_name" {
  default = "test"
}


variable "cidr_block_vpc" {
  default = "10.0.0.0/16"
}

variable "cidr_block_subnet" {
  default = "10.0.1.0/24"
}
