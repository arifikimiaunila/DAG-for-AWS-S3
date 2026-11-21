locals {
  dags_dir      = "${path.module}/../dags"
  pipelines_dir = "${path.module}/../pipelines"
  silver_dir    = "${path.module}/../pipelines/silver"
  schemas_dir   = "${path.module}/../database/schemas"
  raw_data_dir  = "${path.module}/../data/raw"
  requirements_file = "${path.module}/../requirements.txt"

  schema_files = toset([
    "ops.sql",
    "bronze.sql",
    "silver.sql",
    "gold.sql",
  ])

  silver_modules = toset([
    "stage1_lineage.py",
    "stage2_fill_silver.py",
    "count_silver_rows.py",
    "stage3_timestamp.py",
    "stage4_normalization.py",
    "stage5_rejection.py",
    "stage6_dedup.py",
    "stage7_identity.py",
    "stage8_temporal.py",
    "stage9_fk.py",
    "stage10_late.py",
    "stage11_quality_gate.py",
  ])

  raw_data_files = toset([
    "operational/customers.json",
    "operational/customer_addresses.json",
    "operational/customer_profiles.json",
    "operational/products.json",
    "operational/product_categories.json",
    "operational/stores.json",
    "operational/sales_channels.json",
    "operational/promotions.json",
    "operational/orders.json",
    "operational/order_items.json",
    "operational/order_promotions.json",
    "events/payment_events.json",
    "events/refund_events.json",
    "events/return_events.json",
    "events/support_events.json",
    "events/web_events.json",
    "inventory/inventory_snapshots.csv",
    "reference/campaign_spend.csv",
    "reference/city_reference.json",
  ])
}

resource "aws_s3_object" "requirements" {
  bucket       = aws_s3_bucket.airflow.id
  key          = "requirements.txt"
  source       = local.requirements_file
  etag         = filemd5(local.requirements_file)
  content_type = "text/plain"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "dag" {
  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/dag.py"
  source       = "${local.dags_dir}/dag.py"
  etag         = filemd5("${local.dags_dir}/dag.py")
  content_type = "text/x-python"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "raw_data_validation" {
  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/raw_data_validation/raw_data_validation.py"
  source       = "${path.module}/../raw_data_validation/raw_data_validation.py"
  etag         = filemd5("${path.module}/../raw_data_validation/raw_data_validation.py")
  content_type = "text/x-python"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "bronze_script" {
  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/pipelines/bronze/build_bronze.py"
  source       = "${local.pipelines_dir}/bronze/build_bronze.py"
  etag         = filemd5("${local.pipelines_dir}/bronze/build_bronze.py")
  content_type = "text/x-python"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "silver_script" {
  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/pipelines/silver/build_silver.py"
  source       = "${local.pipelines_dir}/silver/build_silver.py"
  etag         = filemd5("${local.pipelines_dir}/silver/build_silver.py")
  content_type = "text/x-python"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "silver_files" {
  for_each = local.silver_modules

  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/pipelines/silver/silver_files/${each.value}"
  source       = "${local.silver_dir}/silver_files/${each.value}"
  etag         = filemd5("${local.silver_dir}/silver_files/${each.value}")
  content_type = "text/x-python"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "gold_script" {
  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/pipelines/gold/build_gold.py"
  source       = "${local.pipelines_dir}/gold/build_gold.py"
  etag         = filemd5("${local.pipelines_dir}/gold/build_gold.py")
  content_type = "text/x-python"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "schema_sqls" {
  for_each = local.schema_files

  bucket       = aws_s3_bucket.airflow.id
  key          = "dags/database/schemas/${each.value}"
  source       = "${local.schemas_dir}/${each.value}"
  etag         = filemd5("${local.schemas_dir}/${each.value}")
  content_type = "application/sql"
  depends_on   = [aws_s3_bucket_versioning.airflow]
}

resource "aws_s3_object" "raw_data_files" {
  for_each = local.raw_data_files

  bucket     = aws_s3_bucket.airflow.id
  key        = "dags/data/raw/${each.value}"
  source     = "${local.raw_data_dir}/${each.value}"
  etag       = filemd5("${local.raw_data_dir}/${each.value}")
  depends_on = [aws_s3_bucket_versioning.airflow]
}