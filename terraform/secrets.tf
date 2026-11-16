resource "aws_secretsmanager_secret" "postgres" {
  name = "postgres-credentials"
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}