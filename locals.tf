locals {
  logs_set = compact([
    var.enable_audit_log ? "audit" : "",
    var.enable_error_log ? "error" : "",
    var.enable_general_log ? "general" : "",
    var.enable_slowquery_log ? "slowquery" : "",
  ])
}