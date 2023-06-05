variable "region" {
  default = "us-east-1"
}


variable "ami" {
  default = "ami-08c40ec9ead489470"
}



variable "instance_type" {
  default = "t2.medium"
}



variable "key_name" {
  default = "automation"
}

variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [8080,80,22,443]
}
