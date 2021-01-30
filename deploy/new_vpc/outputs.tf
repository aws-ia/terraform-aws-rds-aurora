######
# VPC
######

output "vpc_cidr" {
  description = "VPC_CIDR "
  value       = module.aurora_vpc.vpc_cidr
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.aurora_vpc.vpc_id
}
output "NAT1EIP" {
  description = "NAT 1 IP address"
  value       = module.aurora_vpc.NAT1EIP
}

output "NAT2EIP" {
  description = " NAT 2 IP address"
  value       = module.aurora_vpc.NAT2EIP
}

output "NAT3EIP" {
  description = " NAT 3 IP address"
  value       = module.aurora_vpc.NAT3EIP
}

output "NAT4EIP" {
  description = " NAT 4 IP address"
  value       = module.aurora_vpc.NAT4EIP
}

output "PrivateSubnet1ACIDR" {
  description = " Private subnet 1A CIDR in Availability Zone 1"
  value       = module.aurora_vpc.PrivateSubnet1ACIDR
}

output "PrivateSubnet1AID" {
  description = " Private subnet 1A ID in Availability Zone 1"
  value       = module.aurora_vpc.PrivateSubnet1AID
}

output "PrivateSubnet2ACIDR" {
  description = " Private subnet 2A CIDR in Availability Zone 2"
  value       = module.aurora_vpc.PrivateSubnet2ACIDR
}

output "PrivateSubnet2AID" {
  description = " Private subnet 2A ID in Availability Zone 2"
  value       = module.aurora_vpc.PrivateSubnet2AID
}

output "PrivateSubnet3ACIDR" {
  description = " Private subnet 3A CIDR in Availability Zone 3"
  value       = module.aurora_vpc.PrivateSubnet3ACIDR
}

output "PrivateSubnet3AID" {
  description = " Private subnet 3A ID in Availability Zone 3"
  value       = module.aurora_vpc.PrivateSubnet3AID
}

output "PrivateSubnet4ACIDR" {
  description = " Private subnet 4A CIDR in Availability Zone 4"
  value       = module.aurora_vpc.PrivateSubnet4ACIDR
}

output "PrivateSubnet4AID" {
  description = " Private subnet 4A ID in Availability Zone 4"
  value       = module.aurora_vpc.PrivateSubnet4AID
}

output "PublicSubnet1CIDR" {
  description = " Public subnet 1 CIDR in Availability Zone 1"
  value       = module.aurora_vpc.PublicSubnet1CIDR
}

output "PublicSubnet1ID" {
  description = " Public subnet 1 ID in Availability Zone 1"
  value       = module.aurora_vpc.PublicSubnet1ID
}

output "PublicSubnet2CIDR" {
  description = " Public subnet 2 CIDR in Availability Zone 2"
  value       = module.aurora_vpc.PublicSubnet2CIDR
}

output "PublicSubnet2ID" {
  description = " Public subnet 2 ID in Availability Zone 2"
  value       = module.aurora_vpc.PublicSubnet2ID
}

output "PublicSubnet3CIDR" {
  description = " Public subnet 3 CIDR in Availability Zone 3"
  value       = module.aurora_vpc.PublicSubnet3CIDR
}

output "PublicSubnet3ID" {
  description = " Public subnet 3 ID in Availability Zone 3"
  value       = module.aurora_vpc.PublicSubnet3ID
}

output "PublicSubnet4CIDR" {
  description = " Public subnet 4 CIDR in Availability Zone 4"
  value       = module.aurora_vpc.PublicSubnet4CIDR
}

output "PublicSubnet4ID" {
  description = " Public subnet 4 ID in Availability Zone 4"
  value       = module.aurora_vpc.PublicSubnet4ID
}

output "S3VPCEndpoint" {
  description = " S3 VPC Endpoint"
  value       = module.aurora_vpc.S3VPCEndpoint
}

output "PrivateSubnet1ARouteTable" {
  description = " Private subnet 1A route table"
  value       = module.aurora_vpc.PrivateSubnet1ARouteTable
}

output "PrivateSubnet2ARouteTable" {
  description = " Private subnet 2A route table"
  value       = module.aurora_vpc.PrivateSubnet2ARouteTable
}

output "PrivateSubnet3ARouteTable" {
  description = " Private subnet 3A route table"
  value       = module.aurora_vpc.PrivateSubnet3ARouteTable
}

output "PrivateSubnet4ARouteTable" {
  description = " Private subnet 4A route table"
  value       = module.aurora_vpc.PrivateSubnet4ARouteTable
}

output "PublicSubnetRouteTable" {
  description = " Public subnet route table"
  value       = module.aurora_vpc.PublicSubnetRouteTable
}

#######
#Aurora
#######

output "postgresql_rds_cluster_arn" {
  description = "The ID of the cluster"
  value       = module.aurora.postgresql_rds_cluster_arn
}

output "postgresql_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = module.aurora.postgresql_rds_cluster_id
}

output "postgresql_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = module.aurora.postgresql_rds_cluster_resource_id
}

output "postgresql_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora.postgresql_rds_cluster_endpoint
}

output "postgresql_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora.postgresql_rds_cluster_reader_endpoint
}

output "postgresql_rds_cluster_master_password" {
  description = "The master password"
  value       = module.aurora.postgresql_rds_cluster_master_password
  sensitive   = true
}

output "postgresql_rds_cluster_port" {
  description = "The port"
  value       = module.aurora.postgresql_rds_cluster_port
}

output "postgresql_rds_cluster_master_username" {
  description = "The master username"
  value       = module.aurora.postgresql_rds_cluster_master_username
}

output "postgresql_rds_cluster_hosted_zone_id" {
  description = "Route53 hosted zone id of the created cluster"
  value       = module.aurora.postgresql_rds_cluster_hosted_zone_id
}

// module.aurora_instance
output "postgresql_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = module.aurora.postgresql_rds_cluster_instance_endpoints
}

output "postgresql_rds_cluster_instance_ids" {
  description = "A list of all cluster instance ids"
  value       = module.aurora.postgresql_rds_cluster_instance_ids
}