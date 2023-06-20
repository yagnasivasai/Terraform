resource "aws_instance" "www" {
    ami = "${lookup(var.aws_web_amis, data.consul_keys.env.var["aws_region"])}"
    availability_zone = "${element(split(" ",data.consul_keys.env.var["aws_regions"]), count.index % length(split(" ",data.consul_keys.env.var["aws_regions"])) )}"
    connection {
        agent       = false
        type        = "ssh"
        user        = "centos"
        private_key = "..."
    }
    count = 1
    instance_type = "t2.micro"
    key_name = ".."
    provisioner "file" {
        source = "./bin/www.sh"
        destination = "/tmp/www.sh"
    }
    provisioner "remote-exec" {
        inline = [
          "sudo chmod +x /tmp/www.sh"
        ]
    }
    security_groups = [ "..." ]
    subnet_id = "${element(split(" ",data.consul_keys.env.var["aws_public_subnet_ids"]), count.index % length(split(" ",data.consul_keys.env.var["aws_public_subnet_ids"])) )}"
    tags = {
        Name            = "web-${count.index}"
    }
    user_data = "sudo chmod -w /tmp/www.sh"
}
