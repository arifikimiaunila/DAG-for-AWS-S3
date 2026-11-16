resource "aws_s3_object" "dag" {
  bucket = aws_s3_bucket.airflow.bucket
  key    = "dags/dag.py"
  source = "../dags/dag.py"
}

resource "aws_s3_object" "bronze_script" {
  bucket = aws_s3_bucket.airflow.bucket
  key    = "scripts/build_bronze.py"
  source = "../pipelines/bronze/build_bronze.py"
}

resource "aws_s3_object" "silver_script" {
  bucket = aws_s3_bucket.airflow.bucket
  key    = "scripts/build_silver.py"
  source = "../pipelines/silver/build_silver.py"
}

resource "aws_s3_object" "gold_script" {
  bucket = aws_s3_bucket.airflow.bucket
  key    = "scripts/build_gold.py"
  source = "../pipelines/gold/build_gold.py"
}
