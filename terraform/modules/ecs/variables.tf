variable project {
  type = string
}

variable docker_image_url {
  type = string
}

variable docker_image_tag {
  type = string
}

variable default_region {
  type = string
}

variable vpc_id {
  type = string
}

variable security_group_ids {
  type = list(string)
}

variable subnet_ids {
  type = list(string)
}

variable execution_role_arn {
  type = string
}

variable postgres_host_arn {
  type = string
}

variable postgres_user_arn {
  type = string
}

variable postgres_password_arn {
  type = string
}

variable github_token_arn {
  type = string
}

variable github_client_id_arn {
  type = string
}

variable github_client_secret_arn {
  type = string
}

variable tech_docs_bucket_name {
  type = string
}

variable access_key_id_arn {
  type = string
}

variable secret_access_key_arn {
  type = string
}

variable target_group_arn {
  type = string
}

variable alb_dns_name {
  type = string
}
