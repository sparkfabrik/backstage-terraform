# General
project        = "backstage"
region         = "ap-southeast-1"
s3state        = "dev-apse1-interview-s3"
vpc_cidr_block = "172.31.0.0/16"
public_subnets = {
  "ap-southeast-1a" = "172.31.0.0/20",
  "ap-southeast-1b" = "172.31.16.0/20"
}
tags = {
  "environment"     = "dev"
  "created-by"      = "terraform"
  "owner"           = "devops"
  "tag-version"     = "1"
}

access_key_id = "AKIAQVTNHIOW46MRKMOP"
secret_access_key = "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"
github_client_secret = "217ce8505fdaf2de94d850d45c35873d51b943d8"
github_client_id = "7bddff430630ee6f9ed1"
github_token = "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"
