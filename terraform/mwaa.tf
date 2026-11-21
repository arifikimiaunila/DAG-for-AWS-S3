resource "aws_mwaa_environment" "airflow" {
  name               = "${var.project_name}-airflow"
  airflow_version    = "2.9.2"
  environment_class  = "mw1.small"
  execution_role_arn = aws_iam_role.mwaa_role.arn

  source_bucket_arn = aws_s3_bucket.airflow.arn
  dag_s3_path       = "dags"

  network_configuration {
    security_group_ids = [aws_security_group.mwaa.id]
    subnet_ids = [
      aws_subnet.private1.id,
      aws_subnet.private2.id
    ]
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }
    task_logs {
      enabled   = true
      log_level = "INFO"
    }
    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }
    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }
    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.attach_s3,
    aws_s3_bucket_versioning.airflow
  ]
}