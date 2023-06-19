provider "aws" {
    region = var.region
}

module "db" {
    source = "./Web"
    server_names = ["mariadb","mysql","mssql"]
    instance_type = var.instance_type
    ami = var.ami
}