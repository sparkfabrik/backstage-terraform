# [Backstage](https://backstage.io) Terraform demo
## 1. Technical assessment
- [x] Provision a Backstage.io instance using Terraform on AWS
- [] Create a template in Backstage.io that enables a Customer
Technology Engineer to deploy and extend the sample AWS
Web application.
- [] Create a rich Developer Experience for the Customer
Technology Engineers on Backstage.io
- [x] Store the code base for your solution in your preferred SCM
- [] Present your solution (prepare a pack) for the engineering
community of practice.


## 2. Local environment
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
### 2.1 Note
- Credentials:
```
Github OAuth: https://backstage.io/docs/auth/github/provider/
Secret: 217ce8505fdaf2de94d850d45c35873d51b943d8
ID: 7bddff430630ee6f9ed1
PAT: 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
```
- Terraform stuff: S3 and Dynamo Lock table created manually, resource group created manually to manage resources: https://ap-southeast-1.console.aws.amazon.com/resource-groups/group/BackStage_ResourceGroup?region=ap-southeast-1
- Required softwares: git, nvm, node 20, nvm 10.1.0, docker, docker-compose
- To setup a new standalone: `npx @backstage/create-app@latest`
- To run local: `yarn dev` Docs: Set up the software catalog: https://backstage.io/docs/features/software-catalog/configuration, Add authentication: https://backstage.io/docs/auth/
## 3. Infrastructure
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


## 4. AWS deploy
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
docker tag backstage 046399964077.dkr.ecr.ap-southeast-1.amazonaws.com/backstage-image:1.0.0
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 046399964077.dkr.ecr.ap-southeast-1.amazonaws.com
docker push 046399964077.dkr.ecr.ap-southeast-1.amazonaws.com/backstage-image:1.0.0
```
After that, you should wait a few minutes for ECS to be up and running, then you can visit the application by typing the URL of your Load Balancer.
