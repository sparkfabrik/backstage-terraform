terraform {
  backend "s3" {
    bucket               = "dev-apse1-interview-s3"
    dynamodb_table       = "dev-apse1-interview-db-lock-table"
    key                  = "terraform.tfstate"
    region               = "ap-southeast-1"
    workspace_key_prefix = "environment"
  }
}
