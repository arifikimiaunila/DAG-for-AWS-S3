resource "aws_s3_bucket" "data_lake" {
  bucket = "${var.project_name}-datalake"
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

resource "aws_s3_object" "raw" {
  bucket = aws_s3_bucket.data_lake.id
  key    = "raw/"
}
