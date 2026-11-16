output "s3_bucket" {
  value = aws_s3_bucket.data_lake.bucket
}

output "postgres_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "mwaa_webserver" {
  value = aws_mwaa_environment.airflow.webserver_url
}