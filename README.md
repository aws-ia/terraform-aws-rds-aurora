<!-- BEGIN_TF_DOCS -->
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
   2. To deploy Aurora module into existing VPCs, pass the list of private subnets (var.Private\_subnet\_ids\_p & var.Private\_subnet\_ids\_s) directly to the Aurora module.

## Authors and Contributors
   
David Wright (dwright@hashicorp.com), Tony Vattahil (tonynv@amazon.com), Arabinda Pani (arabindp@amazon.com) and [other contributors](https://github.com/aws-ia/terraform-aws-rds-aurora/graphs/contributors).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0 |
| <a name="provider_aws.primary"></a> [aws.primary](#provider\_aws.primary) | >= 4.9.0 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | >= 4.9.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cpu_util_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_util_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_local_storage_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_local_storage_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_random_access_memory_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_random_access_memory_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.pg_max_used_tx_ids_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.pg_max_used_tx_ids_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_event_subscription.default_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_db_event_subscription.default_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_db_parameter_group.aurora_db_parameter_group_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_parameter_group.aurora_db_parameter_group_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.private_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_db_subnet_group.private_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key.kms_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.kms_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_rds_cluster.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_instance.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_rds_global_cluster.globaldb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_sns_topic.default_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.default_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [random_id.snapshot_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.region_p](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_availability_zones.region_s](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.monitoring_rds_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_rds_engine_version.family](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_password"></a> [password](#input\_password) | Master DB password | `string` | n/a | yes |
| <a name="input_private_subnet_ids_p"></a> [private\_subnet\_ids\_p](#input\_private\_subnet\_ids\_p) | A list of private subnet IDs in your Primary AWS region VPC | `list(string)` | n/a | yes |
| <a name="input_private_subnet_ids_s"></a> [private\_subnet\_ids\_s](#input\_private\_subnet\_ids\_s) | A list of private subnet IDs in your Secondary AWS region VPC | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The name of the primary AWS region you wish to deploy into | `string` | n/a | yes |
| <a name="input_sec_region"></a> [sec\_region](#input\_sec\_region) | The name of the secondary AWS region you wish to deploy into | `string` | n/a | yes |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions. Defaults to `false` | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Determines whether minor engine upgrades will be performed automatically in the maintenance window | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | How long to keep backups for (in days) | `number` | `7` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on cluster creation | `string` | `"mydb"` | no |
| <a name="input_enable_audit_log"></a> [enable\_audit\_log](#input\_enable\_audit\_log) | Enable MySQL audit log export to Amazon Cloudwatch. | `bool` | `false` | no |
| <a name="input_enable_error_log"></a> [enable\_error\_log](#input\_enable\_error\_log) | Enable MySQL error log export to Amazon Cloudwatch. | `bool` | `false` | no |
| <a name="input_enable_general_log"></a> [enable\_general\_log](#input\_enable\_general\_log) | Enable MySQL general log export to Amazon Cloudwatch. | `bool` | `false` | no |
| <a name="input_enable_postgresql_log"></a> [enable\_postgresql\_log](#input\_enable\_postgresql\_log) | Enable PostgreSQL log export to Amazon Cloudwatch. | `bool` | `false` | no |
| <a name="input_enable_slowquery_log"></a> [enable\_slowquery\_log](#input\_enable\_slowquery\_log) | Enable MySQL slowquery log export to Amazon Cloudwatch. | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Aurora database engine type: aurora (for MySQL 5.6-compatible Aurora), aurora-mysql (for MySQL 5.7-compatible Aurora), aurora-postgresql | `string` | `"aurora-postgresql"` | no |
| <a name="input_engine_version_mysql"></a> [engine\_version\_mysql](#input\_engine\_version\_mysql) | Aurora database engine version. | `string` | `"5.7.mysql_aurora.2.10.2"` | no |
| <a name="input_engine_version_pg"></a> [engine\_version\_pg](#input\_engine\_version\_pg) | Aurora database engine version. | `string` | `"13.6"` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | `string` | `"final"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Cluster identifier | `string` | `"aurora"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance type to use at replica instance | `string` | `"db.r5.large"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | Enhanced Monitoring interval in seconds | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Prefix for resource names | `string` | `"aurora"` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which to accept connections | `string` | `""` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | When to perform DB backups | `string` | `"02:00-03:00"` | no |
| <a name="input_primary_instance_count"></a> [primary\_instance\_count](#input\_primary\_instance\_count) | instance count for primary Aurora cluster | `number` | `2` | no |
| <a name="input_secondary_instance_count"></a> [secondary\_instance\_count](#input\_secondary\_instance\_count) | instance count for secondary Aurora cluster | `number` | `1` | no |
| <a name="input_setup_as_secondary"></a> [setup\_as\_secondary](#input\_setup\_as\_secondary) | Setup aws\_rds\_cluster.primary Terraform resource as Secondary Aurora cluster after an unplanned Aurora Global DB failover | `bool` | `false` | no |
| <a name="input_setup_globaldb"></a> [setup\_globaldb](#input\_setup\_globaldb) | Setup Aurora Global Database with 1 Primary and 1 X-region Secondary cluster | `bool` | `false` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | skip creating a final snapshot before deleting the DB | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | id of snapshot to restore. If you do not want to restore a db, leave the default empty string. | `string` | `""` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the underlying Aurora storage layer should be encrypted | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | <pre>{<br>  "Name": "aurora-db"<br>}</pre> | no |
| <a name="input_username"></a> [username](#input\_username) | Master DB username | `string` | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_cluster_arn"></a> [aurora\_cluster\_arn](#output\_aurora\_cluster\_arn) | The ARN of the Primary Aurora cluster |
| <a name="output_aurora_cluster_database_name"></a> [aurora\_cluster\_database\_name](#output\_aurora\_cluster\_database\_name) | Name for an automatically created database on Aurora cluster creation |
| <a name="output_aurora_cluster_endpoint"></a> [aurora\_cluster\_endpoint](#output\_aurora\_cluster\_endpoint) | Primary Aurora cluster endpoint |
| <a name="output_aurora_cluster_hosted_zone_id"></a> [aurora\_cluster\_hosted\_zone\_id](#output\_aurora\_cluster\_hosted\_zone\_id) | Route53 hosted zone id of the Primary Aurora cluster |
| <a name="output_aurora_cluster_id"></a> [aurora\_cluster\_id](#output\_aurora\_cluster\_id) | The ID of the Primary Aurora cluster |
| <a name="output_aurora_cluster_instance_endpoints"></a> [aurora\_cluster\_instance\_endpoints](#output\_aurora\_cluster\_instance\_endpoints) | A list of all Primary Aurora cluster instance endpoints |
| <a name="output_aurora_cluster_instance_ids"></a> [aurora\_cluster\_instance\_ids](#output\_aurora\_cluster\_instance\_ids) | A list of all Primary Aurora cluster instance ids |
| <a name="output_aurora_cluster_master_password"></a> [aurora\_cluster\_master\_password](#output\_aurora\_cluster\_master\_password) | Aurora master User password |
| <a name="output_aurora_cluster_master_username"></a> [aurora\_cluster\_master\_username](#output\_aurora\_cluster\_master\_username) | Aurora master username |
| <a name="output_aurora_cluster_port"></a> [aurora\_cluster\_port](#output\_aurora\_cluster\_port) | Primary Aurora cluster endpoint port |
| <a name="output_aurora_cluster_reader_endpoint"></a> [aurora\_cluster\_reader\_endpoint](#output\_aurora\_cluster\_reader\_endpoint) | Primary Aurora cluster reader endpoint |
| <a name="output_aurora_cluster_resource_id"></a> [aurora\_cluster\_resource\_id](#output\_aurora\_cluster\_resource\_id) | The Cluster Resource ID of the Primary Aurora cluster |
<!-- END_TF_DOCS -->