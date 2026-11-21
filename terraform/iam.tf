resource "aws_iam_role" "mwaa_role" {
  name = "${var.project_name}-mwaa-role"

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

resource "aws_iam_policy" "airflow_s3" {
  name = "${var.project_name}-airflow-s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketVersioning"
        ]
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*",
          aws_s3_bucket.airflow.arn,
          "${aws_s3_bucket.airflow.arn}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = "airflow:PublishMetrics"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.mwaa_role.name
  policy_arn = aws_iam_policy.airflow_s3.arn
}