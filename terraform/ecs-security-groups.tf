# Security group: restrict access to the ALB (application port only)
resource "aws_security_group" "alb" {
  name        = "security-group-alb"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.mainvpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.ext_port
    to_port     = var.ext_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group: permit access to the application from ECS only
resource "aws_security_group" "alb_to_ecs" {
    name = "security-group-app-to-alb"
    description = "Permits access to application from ALB only"
    vpc_id = aws_vpc.mainvpc.id

    ingress {
        protocol = "tcp"
        from_port = var.app_port
        to_port = var.app_port
        security_groups = [ aws_security_group.alb.id ]
    }

    egress {
        protocol = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

