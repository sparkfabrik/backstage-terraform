# Variables
variable default_region { 
  type = string 
}

variable project { 
  type = string 
}

variable vpc_cidr_block {
  type = string
}

variable public_subnets {
  type = map
}

variable docker_image_tag {
  type = string
}

variable postgres_user {
  type = string
}

variable postgres_password {
  type = string
}

variable github_token {
  type = string
}

variable github_client_id {
  type = string
}

variable github_client_secret {
  type = string
}

variable access_key_id {
  type = string
}

variable secret_access_key {
  type = string
}
