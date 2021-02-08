# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 
2. Configure the AWS Command Line Interface (CLI). For more information, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
3. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 
4. Clone this **aws-quickstart/terraform-aws-rds_aurora** repository.

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
