resource "aws_ssm_parameter" "postgres_host" {
  name  = "POSTGRES_HOST"
  type  = "String"
  value = var.postgres_host
}

resource "aws_ssm_parameter" "postgres_user" {
  name  = "POSTGRES_USER"
  type  = "String"
  value = var.postgres_user
}

resource "aws_ssm_parameter" "postgres_password" {
  name  = "POSTGRES_PASSWORD"
  type  = "String"
  value = var.postgres_password
}

resource "aws_ssm_parameter" "github_token" {
  name  = "GITHUB_TOKEN"
  type  = "String"
  value = var.github_token
}

resource "aws_ssm_parameter" "github_client_id" {
  name  = "AUTH_GITHUB_CLIENT_ID"
  type  = "String"
  value = var.github_client_id
}

resource "aws_ssm_parameter" "github_client_secret" {
  name  = "AUTH_GITHUB_CLIENT_SECRET"
  type  = "String"
  value = var.github_client_secret
}

resource "aws_ssm_parameter" "access_key_id" {
  name  = "ACCESS_KEY_ID"
  type  = "String"
  value = var.access_key_id
}

resource "aws_ssm_parameter" "secret_access_key" {
  name  = "SECRET_ACCESS_KEY"
  type  = "String"
  value = var.secret_access_key
}
