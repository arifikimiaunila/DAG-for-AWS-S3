resource "aws_cloudwatch_log_group" "airflow" {

  name = "/aws/mwaa/retail-airflow"

  retention_in_days = 30
}