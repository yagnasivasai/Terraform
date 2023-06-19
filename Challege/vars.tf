variable "region" {
  description = "Tell me Which region do i have to deploy"
}

variable "vpc_cidr" {
  description = "Mention the CIDR Block /24 0r /16"
}

variable "instance_type" {
  description = "Which instance type do i have to deploy"
  type        = string
}

variable "ami" {
  description = "Which ami do i have to deploy"
  type        = string
}


variable "ingress" {
  description = "Inbound Rules"
  type = list(number)
}

variable "egress" {
  description = "Outbound Rules"
  type = list(number)
}