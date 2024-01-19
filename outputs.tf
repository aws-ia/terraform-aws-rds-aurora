# aws_rds_cluster
output "primary_aurora_cluster_arn" {
  description = "The ARN of the Primary Aurora cluster"
  value       = aws_rds_cluster.primary.arn
}

output "secondary_aurora_cluster_arn" {
  description = "The ARN of the Secondary Aurora cluster"
  value       = one(aws_rds_cluster.secondary[*].arn)
}

output "primary_aurora_cluster_id" {
  description = "The ID of the Primary Aurora cluster"
  value       = aws_rds_cluster.primary.id
}

output "secondary_aurora_cluster_id" {
  description = "The ID of the Secondary Aurora cluster"
  value       = one(aws_rds_cluster.secondary[*].id)
}

output "primary_aurora_cluster_resource_id" {
  description = "The Cluster Resource ID of the Primary Aurora cluster"
  value       = aws_rds_cluster.primary.cluster_resource_id
}

output "secondary_aurora_cluster_resource_id" {
  description = "The Cluster Resource ID of the Secondary Aurora cluster"
  value       = one(aws_rds_cluster.secondary[*].cluster_resource_id)
}

output "primary_aurora_cluster_endpoint" {
  description = "Primary Aurora cluster endpoint"
  value       = aws_rds_cluster.primary.endpoint
}

output "secondary_aurora_cluster_endpoint" {
  description = "Secondary Aurora cluster endpoint"
  value       = one(aws_rds_cluster.secondary[*].endpoint)
}

output "primary_aurora_cluster_reader_endpoint" {
  description = "Primary Aurora cluster reader endpoint"
  value       = aws_rds_cluster.primary.reader_endpoint
}

output "secondary_aurora_cluster_reader_endpoint" {
  description = "Secondary Aurora cluster reader endpoint"
  value       = one(aws_rds_cluster.secondary[*].reader_endpoint)
}

output "primary_aurora_cluster_port" {
  description = "Primary Aurora cluster endpoint port"
  value       = aws_rds_cluster.primary.port
}

output "secondary_aurora_cluster_port" {
  description = "Secondary Aurora cluster endpoint port"
  value       = one(aws_rds_cluster.secondary[*].port)
}

output "aurora_cluster_database_name" {
  description = "Name for an automatically created database on Aurora cluster creation"
  value       = var.database_name
}

output "aurora_cluster_master_username" {
  description = "Aurora master username"
  value       = aws_rds_cluster.primary.master_username
}

output "aurora_cluster_master_password" {
  description = "Aurora master User password"
  value       = try(aws_rds_cluster.primary.master_password, null)
  sensitive   = true
}

output "primary_aurora_cluster_hosted_zone_id" {
  description = "Route53 hosted zone id of the Primary Aurora cluster"
  value       = aws_rds_cluster.primary.hosted_zone_id
}

output "secondary_aurora_cluster_hosted_zone_id" {
  description = "Route53 hosted zone id of the Secondary Aurora cluster"
  value       = one(aws_rds_cluster.secondary[*].hosted_zone_id)
}

# aws_rds_cluster_instance
output "primary_aurora_cluster_instance_endpoints" {
  description = "A list of all Primary Aurora cluster instance endpoints"
  value       = aws_rds_cluster_instance.primary[*].endpoint
}

output "secondary_aurora_cluster_instance_endpoints" {
  description = "A list of all Secondary Aurora cluster instance endpoints"
  value       = try(aws_rds_cluster_instance.secondary[*].endpoint, null)
}

output "primary_aurora_cluster_instance_ids" {
  description = "A list of all Primary Aurora cluster instance ids"
  value       = aws_rds_cluster_instance.primary[*].id
}

output "secondary_aurora_cluster_instance_ids" {
  description = "A list of all Secondary Aurora cluster instance ids"
  value       = try(aws_rds_cluster_instance.secondary[*].id, null)
}