# terraform-aws-rds-aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)
- Clone this **aws-quickstart/terraform-aws-rds_aurora** directory.
# Terraform AWS RDS Aurora

## Install Terraform
To deploy this module, do the following:
Install Terraform. (See [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) for a tutorial.) 

## Configure AWS CLI 
> ~/.aws/credentials (Linux & Mac)

```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnSAMPLESECRETKEY
```
See [Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) for more info

## Clone the repo (requires git client)

Clone the **aws-quickstart/terraform-aws-rds_aurora** repository.

`git clone https://github.com/aws-quickstart/terraform-aws-rds_aurora`

Change directory to the root directory.

`cd terraform-aws-rds_aurora/`

Change to deploy directory

`cd deploy/new_vpc` or `cd deploy/existing_vpc`

### Local execution

Initialize terraform module

`terraform init`

Run terraform apply

`terraform apply` 

### Remote execution using Terraform Cloud 
@TODO Insert link to Terraform Cloud Deployment walk through
