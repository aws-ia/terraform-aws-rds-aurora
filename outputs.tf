// aws_rds_cluster
output "postgresql_rds_cluster_arn" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.postgresql.arn
}

output "postgresql_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.postgresql.id
}

output "postgresql_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = aws_rds_cluster.postgresql.cluster_resource_id
}

output "postgresql_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.postgresql.endpoint
}

output "postgresql_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.postgresql.reader_endpoint
}

// database_name is not set on `aws_rds_cluster` resource if it was not specified, so can't be used in output
output "postgresql_rds_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = var.database_name
}

output "postgresql_rds_cluster_master_password" {
  description = "The master password"
  value       = aws_rds_cluster.postgresql.master_password
  sensitive   = true
}

output "postgresql_rds_cluster_port" {
  description = "The port"
  value       = aws_rds_cluster.postgresql.port
}

output "postgresql_rds_cluster_master_username" {
  description = "The master username"
  value       = aws_rds_cluster.postgresql.master_username
}

output "postgresql_rds_cluster_hosted_zone_id" {
  description = "Route53 hosted zone id of the created cluster"
  value       = aws_rds_cluster.postgresql.hosted_zone_id
}

// aws_rds_cluster_instance
output "postgresql_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = aws_rds_cluster_instance.postgresql.*.endpoint
}

output "postgresql_rds_cluster_instance_ids" {
  description = "A list of all cluster instance ids"
  value       = aws_rds_cluster_instance.postgresql.*.id
}
