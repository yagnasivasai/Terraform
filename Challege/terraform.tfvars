region        = "us-east-2"
vpc_cidr      = "10.10.0.0/16"
instance_type = "t2.micro"
ami           = "ami-024e6efaf93d85776"
ingress       = [22, 80, 443]
egress        = [80, 443]
