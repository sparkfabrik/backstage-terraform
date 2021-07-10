# [Backstage](https://backstage.io) Terraform demo

This is your newly scaffolded Backstage App, Good Luck!

## Local environment
To start the app, create your .env file from the `.env.template` file and insert these required env variables:

- your AWS credentials
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
- BUCKET_NAME: the name of the bucket for techdocs
- GITHUB_TOKEN: your Github token to allow Backstage to connect to your repositories
- your Github Oauth app for Backstage authentication:
  - AUTH_GITHUB_CLIENT_ID
  - AUTH_GITHUB_CLIENT_SECRET

Then run:

```sh
make
```
This will build the docker image and start the containers for the application and the database, after the build finishes you can visit the application at:
```sh
localhost:3000
```

## Infrastructure
This demo uses Terraform to define and manage the AWS infrastructure that Backstage will use.  
All the Terraform files are in the `terraform` directory, here's a list of the modules and the relative services:
- `vpc`: 1 VPC, 2 subnets, 1 internet gateway and 1 route table
- `alb`: 1 security group and 1 Application Load Balancer
- `rds`: 1 security group and 1 RDS PostgreSQL instance
- `s3`: 1 private bucket
- `ssm`: 8 Parameter Store secrets
- `iam`: 3 policies, 1 role
- `ecr`: 1 ECR repository
- `ecs`: 1 cluster, 1 Cloudwatch log group, 1 task definition and 1 service


## AWS deploy
To deploy your Backstage application on AWS with Terraform you must first set these env variables:
- TF_VAR_github_token
- TF_VAR_github_client_id
- TF_VAR_github_client_secret
- TF_VAR_access_key_id
- TF_VAR_secret_access_key

Then run `make` to build the Terraform container

To let Terraform work, you need to manually create an S3 bucket in which Terraform will save the state of your infrastructure.  
Once created, save the bucket name by replacing the `{{BUCKET-NAME}}` placeholder in the `terraform / terraform.tf` file.

The setup is now complete. To deploy, enter the terraform container by typing `make terraform-cli` and then:
```sh
terraform init
terraform apply
```

As soon as Terraform is done, build your Backstage Docker image and push it on the Elastic Container Registry.  
To build and tag the image run:
```sh
docker build . -f packages/backend/Dockerfile --tag backstage
docker tag backstage {{AWS-ACCOUNT-ID}}.dkr.ecr.eu-west-1.amazonaws.com/backstage-image:1.0.0
```

Then login on ECR with:
```sh
  aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin {{AWS-ACCOUNT-ID}}.dkr.ecr.eu-west-1.amazonaws.com
```

To push the image run:
```sh
docker push {{AWS-ACCOUNT-ID}}.dkr.ecr.eu-west-1.amazonaws.com/backstage-image:1.0.0
```
> remember to replace `{{AWS-ACCOUNT-ID}}` with your AWS account id!

After that, you should wait a few minutes for ECS to be up and running, then you can visit the application by typing the URL of your Load Balancer.

Enjoy!