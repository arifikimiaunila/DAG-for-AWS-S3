resource "aws_security_group" "mwaa" {
  name   = "mwaa-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "postgres" {
  name   = "postgres-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "postgres_from_mwaa" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"

  security_group_id        = aws_security_group.postgres.id
  source_security_group_id = aws_security_group.mwaa.id
}