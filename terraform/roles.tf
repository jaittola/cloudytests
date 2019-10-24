
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "secrets_access_policy" {
  statement {
    actions = [
        "secretsmanager:GetSecretValue"
    ]

    resources = [
      "${aws_secretsmanager_secret.db_url.id}"
    ]
  }
}

resource "aws_iam_role" "ecs_task_excution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_excution_role_policy" {
  role = aws_iam_role.ecs_task_excution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_access_role" {
  policy = data.aws_iam_policy_document.secrets_access_policy.json
  role = aws_iam_role.ecs_task_excution_role.name
}

resource "aws_iam_role" "ecs-instance-role" {
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role = "${aws_iam_role.ecs-instance-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  path = "/"
  role = "${aws_iam_role.ecs-instance-role.id}"
  /*
  provisioner "local-exec" {
    command = "sleep 60"
  }
  */
}

resource "aws_iam_role" "ecs-service-role" {
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
