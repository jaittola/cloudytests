provider "aws" {
  profile = "default"
  region = var.region
}

resource "aws_instance" "munmasiina" {
  ami = "ami-00aa4671cbf840d82"
  instance_type = var.instance_type

  provisioner "local-exec" {
      command = "echo ${aws_instance.munmasiina.public_ip} > public-ip.txt"
  }
}
