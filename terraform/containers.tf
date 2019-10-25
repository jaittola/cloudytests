
resource "aws_ecs_cluster" "maincluster" {
     name = "fancyapp-maincluster"
}

resource "aws_ecs_task_definition" "fancyapp" {
    execution_role_arn       = aws_iam_role.ecs_task_excution_role.arn
    family                   = "fancyapp"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions =  <<DEFINITION
[
  {
    "essential": true,
    "image": "106820074386.dkr.ecr.eu-central-1.amazonaws.com/fancyapp-repo:latest",
    "name": "fancyapp",
    "portMappings" : [
        {
            "containerPort": 8000,
            "hostPort": 8000
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "logs-fancyapp",
            "awslogs-region": "eu-central-1",
            "awslogs-stream-prefix": "fancyapp-app"
        }
    },
    "secrets": [{
        "name": "DB_URI",
        "valueFrom": "${aws_secretsmanager_secret.db_url.id}"
    }],
    "environment": [
        { "name": "FRONTEND_URI", "value": "${var.frontend_protocol}${var.frontend_name}" }
    ]
  }
]
DEFINITION
    depends_on = [ aws_instance.ecs_container_host ]
}

resource "aws_ecs_service" "main" {
    name            = "cb-service"
    cluster         = aws_ecs_cluster.maincluster.id
    task_definition = aws_ecs_task_definition.fancyapp.arn
    desired_count   = var.service_count
    launch_type     = "EC2"

    network_configuration {
        security_groups  = [aws_security_group.alb_to_ecs.id]
        subnets          = aws_subnet.public_subnets.*.id
    }

    load_balancer {
        target_group_arn = aws_alb_target_group.fancyapp.id
        container_port   = var.app_port
        container_name   = "fancyapp"
    }

    depends_on = [ aws_instance.ecs_container_host, aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_excution_role_policy, aws_db_instance.devdb ]
}
