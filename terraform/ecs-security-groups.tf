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

# Security group: permit access to the application from ALB only
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

resource "aws_security_group" "app_to_rds" {
    name = "security-group-app-to-rds"
    description = "Controls access to the database"
    vpc_id = aws_vpc.mainvpc.id

    ingress {
        protocol = "tcp"
        from_port = var.db_port
        to_port = var.db_port
        security_groups = [ aws_security_group.alb_to_ecs.id ]
    }
/*
    ingress {
      protocol = "tcp"
      from_port = var.db_port
      to_port = var.db_port
      cidr_blocks = [ "62.165.154.0/24" ]
      description = "My current IP"
    }
*/
    egress {
        protocol = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
