
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_cidr_block" {
  default = "10.0.0.0/24"
}

variable "private_cidr_block" {
  default = "10.0.10.0/24"
}


variable "az" {
  default = "us-east-1"
}

variable "public_az" {
   default = "us-east-1a"
}

variable "private_az" {
   default = "us-east-1b"
}