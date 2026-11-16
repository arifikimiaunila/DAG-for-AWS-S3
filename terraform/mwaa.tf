resource "aws_iam_role" "mwaa_role" {

  name = "mwaa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "airflow.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}