resource "aws_alb" "alb" {
    subnets         = aws_subnet.public_subnets.*.id
    security_groups = [aws_security_group.alb.id]
    enable_http2    = false
    enable_cross_zone_load_balancing = true
}

resource "aws_alb_target_group" "fancyapp" {
    name        = "cb-target-group"
    port        = var.app_port
    protocol    = "HTTP"
    vpc_id      = aws_vpc.mainvpc.id
    target_type = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = var.health_check_path
        unhealthy_threshold = "2"
    }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
    load_balancer_arn = aws_alb.alb.id
    port              = var.app_port
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.fancyapp.id
        type             = "forward"
    }
}

output "alb_hostname" {
  value = aws_alb.alb.dns_name
}
