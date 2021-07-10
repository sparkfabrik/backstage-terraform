output postgres_host_arn {
  value = aws_ssm_parameter.postgres_host.arn
}

output postgres_user_arn {
  value = aws_ssm_parameter.postgres_user.arn
}

output postgres_password_arn {
  value = aws_ssm_parameter.postgres_password.arn
}

output github_token_arn {
  value = aws_ssm_parameter.github_token.arn
}

output github_client_id_arn {
  value = aws_ssm_parameter.github_client_id.arn
}

output github_client_secret_arn {
  value = aws_ssm_parameter.github_client_secret.arn
}

output access_key_id_arn {
  value = aws_ssm_parameter.access_key_id.arn
}

output secret_access_key_arn {
  value = aws_ssm_parameter.secret_access_key.arn
}
