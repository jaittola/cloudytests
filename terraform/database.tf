
resource "aws_db_subnet_group" "devdb_group" {
    subnet_ids = aws_subnet.db_subnets[*].id
}

resource "aws_db_instance" "devdb" {
  allocated_storage    = 20
  max_allocated_storage = 21
  storage_type         = "gp2"
  engine               = "postgres"
  port                 = var.db_port
  engine_version       = "11.5"
  instance_class       = "db.t2.micro"
  name                 = "lokidbtesti"
  username             = "userfordb"
  password             = "NF84uiwAFTy6BFS171paU7l.2Ni3Cf,.LL.q"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.devdb_group.name
  vpc_security_group_ids = [aws_security_group.app_to_rds.id]
  publicly_accessible = true
}

resource "aws_secretsmanager_secret" "db_url" {
}

resource "aws_secretsmanager_secret_version" "db_url" {
  secret_id = aws_secretsmanager_secret.db_url.id
  secret_string = "postgres://${aws_db_instance.devdb.username}:${aws_db_instance.devdb.password}@${aws_db_instance.devdb.endpoint}/${aws_db_instance.devdb.name}?sslmode=require"
}

output "devdb_url" {
  value = aws_secretsmanager_secret_version.db_url.secret_string
}
