> Note: This module is in alpha state and is likely to contain bugs and updates may introduce breaking changes. It is not recommended for production use at this time.

# Terraform Amazon Aurora
Terraform module for automating deployment of Amazon Aurora and related resources following AWS best practices.

## Supported Features
- Aurora Provisioned cluster (MySQL & PostgreSQL)
- Aurora Global databases (MySQL & PostgreSQL)

## Deployment Procedure

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 

2. Sign up and log into [Terraform Cloud](https://www.terraform.io/cloud) (There is a free tier available).
   1.  Create a [Terraform organization](https://www.terraform.io/docs/cloud/users-teams-organizations/organizations.html#creating-organizations).

3. Configure [Terraform Cloud API access](https://learn.hashicorp.com/tutorials/terraform/cloud-login). Run the following to generate a Terraform Cloud token from the command line interface:
   ```
   terraform login

   --For Mac/Linux
   export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"

   --For Windows
   export TERRAFORM_CONFIG="$HOME/AppData/Roaming/terraform.d/credentials.tfrc.json"
   ```

4. [Install](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) the AWS Command Line Interface (AWS CLI).

5. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 

6. Clone this **aws-ia/terraform-aws-rds-aurora** repository using the following command:

   `git clone https://github.com/aws-ia/terraform-aws-rds-aurora.git`

7. Change directory to the root repository directory.

   `cd terraform-aws-rds-aurora/`

8. Set up a new terraform workspace.
   
   ```
   cd setup_workspace
   terraform init
   terraform apply
   ```

9. Deploy Aurora Terraform module.
   1. To create VPC and deploy Aurora module
      - Change to the deploy directory. Run `cd ../deploy`
      - Initialize the deploy directory. Run `terraform init`.
      - Start a Terraform run using the configuration files in your deploy directory. Run `terraform apply`  or `terraform apply -var-file="$HOME/.aws/terraform.tfvars"` (Note: The deployment is remotely run in Terraform Cloud)
   2. To deploy Aurora module into existing VPCs, pass the list of private subnets (var.Private_subnet_ids_p & var.Private_subnet_ids_s) directly to the Aurora module.

## Authors and Contributors
   
David Wright (dwright@hashicorp.com), Tony Vattahil (tonynv@amazon.com), Arabinda Pani (arabindp@amazon.com) and [other contributors](https://github.com/aws-ia/terraform-aws-rds-aurora/graphs/contributors).