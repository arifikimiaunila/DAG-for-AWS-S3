resource "aws_s3_bucket" "data_lake" {
  bucket = "${var.project_name}-datalake"
}

resource "aws_s3_object" "raw" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "raw/"
}

resource "aws_s3_object" "bronze" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "bronze/"
}

resource "aws_s3_object" "silver" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "silver/"
}

resource "aws_s3_object" "gold" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "gold/"
}

resource "aws_s3_bucket" "airflow" {
  bucket = "${var.project_name}-airflow-dags"
}

resource "aws_s3_bucket_versioning" "airflow" {
  bucket = aws_s3_bucket.airflow.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "airflow" {
  bucket = aws_s3_bucket.airflow.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}