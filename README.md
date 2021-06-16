# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 
2. Sign up and log into Terraform Cloud. (There is a free tier available.)
3. Configure Terraform Cloud API access. Run the following to generate a Terraform Cloud token from the command line interface:
```
terraform login
Export the TERRAFORM_CONFIG variable
export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"
```

4. Configure the AWS Command Line Interface (AWS CLI). For more information, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
5. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 
6. Clone this **aws-ia/terraform-aws-rds-aurora** repository using the following command:

   `git clone https://github.com/aws-ia/terraform-aws-rds-aurora`

7. Change directory to the root repository directory.

   `cd terraform-aws-rds-aurora/`

8. Change to the deploy directory.

   - For a new virtual private cloud (VPC), use `cd setup_workspace`. 
   - For an existing VPC, pass the VPC ID directly to the module.

9. To perform operations locally, do the following: 
   
   a. Initialize the deploy directory. Run `terraform init`.  
   b. Start a Terraform run using the configuration files in your deploy directory. Run `terraform apply` or `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`.
 
10. Change to the deploy directory with `cd ../deploy`.
11. Run `terraform init`.
12. Run `terraform apply` or Run `terraform apply  -var-file="$HOME/.aws/terraform.tfvars"`. `Terraform apply` is remotely run in Terraform Cloud. 
