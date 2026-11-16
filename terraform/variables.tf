variable "aws_region" {
  default = "ap-southeast-3"
}

variable "project_name" {
  default = "retail-medallion"
}

variable "db_username" {
  default = "postgres"
}

variable "db_password" {
  sensitive = true
}