resource "aws_db_subnet_group" "postgres" {
  name = "postgres-subnet-group"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]
}

resource "aws_db_instance" "postgres" {
  identifier             = "retail-postgres"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  db_name                = "retail_analytics"
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.postgres.id]
  skip_final_snapshot    = true

  db_subnet_group_name = aws_db_subnet_group.postgres.name
}