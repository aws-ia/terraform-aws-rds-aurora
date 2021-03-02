# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 
2. Sign up and log into Terraform Cloud. (There is a free tier available.)
3. Configure Terraform Cloud API access. Run the following to generate a Terraform Cloud token from the command line interface:
```
terraform login
Export TERRAFORM_CONFIG
export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"
```

3. Configure the AWS Command Line Interface (AWS CLI). For more information, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
4. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 
5. Clone this **aws-quickstart/terraform-aws-rds_aurora** repository using the following command:

   `git clone https://github.com/aws-quickstart/terraform-aws-rds_aurora`

6. Change directory to the root repository directory.

   `cd terraform-aws-rds_aurora/`

7. Change to the deploy directory.

   - For a new virtual private cloud (VPC), use `cd setup_workspace`. 
   - For an existing VPC, pass the VPC ID directly to the module.

8. To perform operations locally, do the following: 
   
   a. Initialize the deploy directory. Run `terraform init`.
   b. Start a Terraform run using the configuration files in your deploy directory. 
   Run `terraform apply` or Run `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`
 
9. Change to the deploy directory with `cd ../deploy`.
10. Run `terraform init`.
11. Run `terraform apply` or Run `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`. `Terraform apply` is remotely run in Terraform Cloud. 
