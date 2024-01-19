output "aurora_vpc_p" {
  value = module.aurora_vpc_p
}
output "aurora_vpc_s" {
  value = module.aurora_vpc_s
}
output "aurora" {
  #   value = module.aurora
  value = { for k, v in module.aurora : k => v if k != "aurora_cluster_master_password" }
}

output "aurora_cluster_master_password" {
  description = "Aurora master User password"
  value       = module.aurora.aurora_cluster_master_password
  sensitive   = true
}