
resource "aws_security_group" "sg_ssh_in" {
    name = "sg_ssh_in"
    vpc_id = aws_vpc.mainvpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ecs_container_host" {
  ami = var.ecs_container_ami_id
  instance_type = var.instance_type
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [ aws_security_group.sg_ssh_in.id,  aws_security_group.alb_to_ecs.id ]
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id
  associate_public_ip_address = true
  user_data = <<USERDATA
#!/bin/bash
sudo mkdir -p /etc/ecs/
sudo echo 'ECS_CLUSTER=fancyapp-maincluster' >> /etc/ecs/ecs.config
sudo yum update -y
sudo yum install -y ec2-instance-connect
USERDATA
}

output "hostname" {
    value = aws_instance.ecs_container_host.public_dns
}

output "host_id" {
    value = aws_instance.ecs_container_host.id
}
