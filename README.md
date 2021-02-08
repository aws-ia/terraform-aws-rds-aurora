# Terraform Amazon Aurora
Authors: David Wright (dwright@hashicorp.com) and Tony Vattahil (tonynv@amazon.com)

To deploy the Terraform Amazon Aurora module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). 
2. Configure the AWS Command Line Interface (CLI). For more information, see [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
3. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). 
4. Clone this **aws-quickstart/terraform-aws-rds_aurora** repository using the following command:

`git clone https://github.com/aws-quickstart/terraform-aws-rds_aurora`

5. Change directory to the root repository directory.

`cd terraform-aws-rds_aurora/`

6. Change to deploy directory.

`cd deploy/new_vpc` or `cd deploy/existing_vpc`

7. To perform local execution, do the following: 
   
   a. Initialize the deploy directory.
   
   `terraform init`

   b. Start a Terraform run using the configuraiton files in your deploy directory, use the following command:
   
   `terraform apply`.
   
8. To perform remote execution using Terraform Cloud, see 
