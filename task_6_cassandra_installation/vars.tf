variable "vpc" {
  type        = string
  description = "VPC for the EC2 instance"
  default     = "192.168.0.0/20"
}
variable "subnet" {
  type        = string
  description = "subnet for the EC2 instance"
  default     = "192.168.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
  sensitive   = true
}
variable "AvailabilityZone" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
}
variable "ami_id" {
  type        = string
  description = "AMi id for the EC2 instance"
  default     = "ami-0b0af3577fe5e3532"
}