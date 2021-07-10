data "aws_caller_identity" "current" {}

### VPC
module "aws_vpc" {
  source         = "./modules/vpc"
  project        = var.project
  vpc_cidr_block = var.vpc_cidr_block
  public_subnets = var.public_subnets
}

### ALB
module "aws_alb" {
  source             = "./modules/alb"
  project            = var.project
  vpc_id             = module.aws_vpc.vpc_id
  subnet_ids         = values(module.aws_vpc.public_subnets)
  depends_on         = [module.aws_vpc]
}

### RDS
module "aws_rds" {
  source                    = "./modules/rds"
  project                   = var.project
  storage                   = 20
  username                  = var.postgres_user
  password                  = var.postgres_password
  subnet_ids                = values(module.aws_vpc.public_subnets)
  vpc_id                    = module.aws_vpc.vpc_id
  default_security_group_id = module.aws_alb.default_security_group_id
  depends_on                = [module.aws_vpc, module.aws_alb]
}

### S3
module "aws_s3" {
  source     = "./modules/s3"
  project    = var.project
  name       = "${var.project}-techdocs-demo-${data.aws_caller_identity.current.account_id}"
  acl        = "private"
  versioning = false
}

### SSM
module "aws_ssm" {
  source               = "./modules/ssm"
  project              = var.project
  postgres_host        = module.aws_rds.rds_instance_endpoint
  postgres_user        = var.postgres_user
  postgres_password    = var.postgres_password
  github_token         = var.github_token
  github_client_id     = var.github_client_id
  github_client_secret = var.github_client_secret
  access_key_id        = var.access_key_id
  secret_access_key    = var.secret_access_key
  depends_on           = [module.aws_rds]
}

### IAM
module "aws_iam" {
  source  = "./modules/iam"
  project = var.project
}

### ECR
resource "aws_ecr_repository" "registry" {
  name                 = "${var.project}-image"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

### ECS
module "aws_ecs" {
  source                   = "./modules/ecs"
  project                  = var.project
  docker_image_url         = aws_ecr_repository.registry.repository_url
  docker_image_tag         = var.docker_image_tag
  default_region           = var.default_region
  vpc_id                   = module.aws_vpc.vpc_id
  security_group_ids       = [module.aws_alb.default_security_group_id]
  subnet_ids               = values(module.aws_vpc.public_subnets)
  execution_role_arn       = module.aws_iam.ecs_role_arn
  postgres_host_arn        = module.aws_ssm.postgres_host_arn
  postgres_user_arn        = module.aws_ssm.postgres_user_arn
  postgres_password_arn    = module.aws_ssm.postgres_password_arn
  github_token_arn         = module.aws_ssm.github_token_arn
  github_client_id_arn     = module.aws_ssm.github_client_id_arn
  github_client_secret_arn = module.aws_ssm.github_client_secret_arn
  tech_docs_bucket_name    = module.aws_s3.tech_docs_bucket_name
  access_key_id_arn        = module.aws_ssm.access_key_id_arn
  secret_access_key_arn    = module.aws_ssm.secret_access_key_arn
  target_group_arn         = module.aws_alb.target_group_arn
  alb_dns_name             = module.aws_alb.alb_dns_name
  depends_on               = [module.aws_vpc, module.aws_alb, module.aws_s3, module.aws_ssm, module.aws_iam]
}
