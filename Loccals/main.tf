locals {
  fallback_value = "default"
  optional_value = null
  result         = coalesce(local.optional_value, local.fallback_value)
}


provider "aws" {
  region = "us-east-2"
}

variable "environment" {
  default = "development"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"] # Canonical official
}


resource "aws_instance" "example" {
  count         = 3
  instance_type = "t3.micro"
  ami           = data.aws_ami.ubuntu.id
  tags = {
    Name = "${join("-", ["web", "app", count.index + 1, var.environment])}"
    /* environment = var.environment */
  }
}


locals {
  environment_vars = {
    "dev"  = "development"
    "prod" = "production"
  }

  current_environment = "prod"
  environment_type    = lookup(local.environment_vars, local.current_environment, "unknown")
}

locals {
  regions        = ["us-west-1", "us-east-1", "eu-west-1"]
  primary_region = element(local.regions, 1)
}

resource "aws_s3_bucket" "example" {
  count  = 3
  bucket = format("my-bucket-%02d", count.index + 1)
}
