# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 

## Sign up for Terraform Cloud

> Sign up and log into Terraform Cloud. (There is a free tier available.)
## Configure Terraform Cloud API Access

Generate terraform cloud token from cli
terraform login
Export TERRAFORM_CONFIG
export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"

3. Configure the AWS Command Line Interface (CLI). For more information, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 
4. Clone this **aws-quickstart/terraform-aws-rds_aurora** repository using the following command:

   `git clone https://github.com/aws-quickstart/terraform-aws-rds_aurora`

5. Change directory to the root repository directory.

   `cd terraform-aws-rds_aurora/`

6. Change to the deploy directory.

   - For a new virtual private cloud (VPC), use `cd setup_workspace`. 

   Note: For an existing VPC, use pass in you VPCID directly into module.

7. To perform operations locally, do the following: 
   
   a. Initialize the deploy directory. Run `terraform init`.

   b. Start a Terraform run using the configuration files in your deploy directory. 
   Run `terraform apply` or Run `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`
 
8. cd ../deploy
9. Run `terraform init`
10. Run `terraform apply` or Run `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`
11. Terraform apply will be remotely executed in Terraform Cloud 
