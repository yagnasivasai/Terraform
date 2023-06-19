variable "region" {
  description = "Tell me Which region do i have to deploy"
}
variable "instance_type" {
  description = "Which instance type do i have to deploy"
  type        = string
}

variable "ami" {
  description = "Which ami do i have to deploy"
  type        = string
}
