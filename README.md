# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. See [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) for instructions and a video tutorial. 

2. Configure AWS CLI 
> ~/.aws/credentials (Linux & Mac)

```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnSAMPLESECRETKEY
```
See [Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) for more info

## 3. Clone this repository (requires git client)

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
