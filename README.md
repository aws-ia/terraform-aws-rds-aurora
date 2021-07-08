# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 

2. Sign up and log into Terraform Cloud. (There is a free tier available.)

3. Configure Terraform Cloud API access. Run the following to generate a Terraform Cloud token from the command line interface:
```
terraform login

--For Mac/Linux
export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"

--For Windows
export TERRAFORM_CONFIG="$HOME/AppData/Roaming/terraform.d/credentials.tfrc.json"
```

4. Configure the AWS Command Line Interface (AWS CLI). For more information, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).

5. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 

6. Clone this **aws-ia/terraform-aws-rds-aurora** repository using the following command:

   `git clone https://github.com/aws-ia/terraform-aws-rds-aurora.git`

7. Change directory to the root repository directory.

   `cd terraform-aws-rds-aurora/`

8. For setting up a new terraform workspace:
   
      - `cd setup_workspace`
      - `terraform init`
      - `terraform apply`

9. To create new VPC and deploy Aurora module:
      - Change to the deploy directory. Run `cd ../deploy`
      - Initialize the deploy directory. Run `terraform init`.
      - Start a Terraform run using the configuration files in your deploy directory. Run `terraform apply`  or `terraform apply -var-file="$HOME/.aws/terraform.tfvars"` (Note: The deployment is remotely run in Terraform Cloud)
   
   For existing VPCs, pass the list of private subnets (var.Private_subnet_ids_p & var.Private_subnet_ids_s) directly to the Aurora module.