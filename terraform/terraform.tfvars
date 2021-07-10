# General
project = "backstage"
default_region = "eu-west-1"
vpc_cidr_block = "172.31.0.0/16"
public_subnets = {
  "eu-west-1a" = "172.31.0.0/20",
  "eu-west-1b" = "172.31.16.0/20"
}
