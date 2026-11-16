# Omnichannel Retail - Medallion Architecture on AWS

Pipeline:

```text
Raw Data
    ↓
Bronze Layer
    ↓
Silver Layer
    ↓
Gold Layer
    ↓
PostgreSQL Analytics
```

Infrastructure is fully provisioned using Terraform and deployed on AWS Managed Services.

## Architecture

```text
Terraform
    ↓
Creates

VPC
├── S3 Data Lake
│   ├── raw/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── Amazon MWAA
│   ├── DAG
│   ├── ETL Scripts
│   └── Requirements
│
├── Amazon RDS PostgreSQL
│   ├── bronze schema
│   ├── silver schema
│   ├── gold schema
│   └── ops schema
│
├── IAM Roles
├── Secrets Manager
├── Security Groups
└── CloudWatch Monitoring
```

## Repository Structure

```text
.
├── dags/
│   └── dag.py
│
├── database/
│   └── schemas/
│       ├── bronze.sql
│       ├── silver.sql
│       ├── gold.sql
│       └── ops.sql
│
├── pipelines/
│   ├── bronze/
│   │   └── build_bronze.py
│   ├── silver/
│   │   └── build_silver.py
│   └── gold/
│       └── build_gold.py
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── networking.tf
│   ├── security_groups.tf
│   ├── iam.tf
│   ├── s3.tf
│   ├── rds.tf
│   ├── secrets.tf
│   ├── mwaa.tf
│   ├── uploads.tf
│   ├── cloudwatch.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
└── evidence/
    └── airflow_run.png
```

## Principles

1. Idempotent pipeline execution.
2. `pipeline_run_id` passed between tasks using XCom.
3. Quality gate stops downstream processing when validation fails.
4. Operational logs are stored in the `ops` schema.
5. Infrastructure provisioned using Infrastructure as Code (Terraform).
6. All AWS resources are reproducible from code.

## AWS Services

| Service | Purpose |
|----------|----------|
| Amazon S3 | Raw, Bronze, Silver, Gold storage |
| Amazon MWAA | Apache Airflow orchestration |
| Amazon RDS PostgreSQL | Analytical data warehouse |
| AWS IAM | Access control |
| AWS Secrets Manager | Credential management |
| Amazon CloudWatch | Monitoring and logging |
| Amazon VPC | Network isolation |
| Terraform | Infrastructure provisioning |

## Deployment Prerequisites

- AWS Account
- Terraform >= 1.6
- AWS CLI
- Python >= 3.11

## Configure AWS Credentials

```bash
aws configure
```

Fill:

```text
AWS Access Key ID
AWS Secret Access Key
Region: ap-southeast-3
Output format: json
```

Verify:

```bash
aws sts get-caller-identity
```

## Deploy Infrastructure

Move to Terraform folder:

```bash
cd terraform
```

Initialize Terraform:

```bash
terraform init
```

Review Execution Plan:

```bash
terraform plan
```

Deploy Infrastructure:

```bash
terraform apply
```

Type:

```text
yes
```

Terraform will automatically create:

- VPC
- Subnets
- Security Groups
- IAM Roles
- Amazon S3 Data Lake
- Amazon MWAA
- Amazon RDS PostgreSQL
- AWS Secrets Manager
- Amazon CloudWatch
- DAG Upload
- ETL Script Upload

## Access Airflow

Retrieve MWAA URL:

```bash
terraform output mwaa_webserver
```

Open the generated URL in your browser.

## Access PostgreSQL

Retrieve endpoint:

```bash
terraform output postgres_endpoint
```

Connection example:

```text
Host     : <terraform output postgres_endpoint>
Port     : 5432
Database : retail_analytics
```

## Data Lake Layout

```text
s3://retail-datalake/

raw/
bronze/
silver/
gold/
```

## ETL Flow

```text
raw_data_validation
          ↓
build_bronze
          ↓
build_silver
          ↓
build_gold
```

## Monitoring

All Airflow and infrastructure logs are centralized in:

```text
Amazon CloudWatch
```

## Destroy Infrastructure

To avoid AWS charges:

```bash
terraform destroy
```

Type:

```text
yes
```

All AWS resources created by Terraform will be removed automatically.
