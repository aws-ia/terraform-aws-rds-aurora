locals {
  apg_cluster_pgroup_params = [{
    name         = "rds.force_autovacuum_logging_level"
    value        = "warning"
    apply_method = "immediate"
    }, {
    name         = "rds.force_admin_logging_level"
    value        = "warning"
    apply_method = "immediate"
    }, {
    name         = "rds.enable_plan_management"
    value        = 1
    apply_method = "pending-reboot"
  }]

  apg_db_pgroup_params = [{
    name         = "shared_preload_libraries"
    value        = "auto_explain,pg_stat_statements,pg_hint_plan,pgaudit"
    apply_method = "pending-reboot"
    }, {
    name         = "log_lock_waits"
    value        = 1
    apply_method = "immediate"
    }, {
    name         = "log_statement"
    value        = "ddl"
    apply_method = "immediate"
    }, {
    name         = "log_temp_files"
    value        = 4096
    apply_method = "immediate"
    }, {
    name         = "log_min_duration_statement"
    value        = 5000
    apply_method = "immediate"
    }, {
    name         = "auto_explain.log_min_duration"
    value        = 5000
    apply_method = "immediate"
    }, {
    name         = "auto_explain.log_verbose"
    value        = 1
    apply_method = "immediate"
    }, {
    name         = "log_rotation_age"
    value        = 1440
    apply_method = "immediate"
    }, {
    name         = "log_rotation_size"
    value        = "102400"
    apply_method = "immediate"
    }, {
    name         = "rds.log_retention_period"
    value        = 10080
    apply_method = "immediate"
    }, {
    name         = "random_page_cost"
    value        = 1
    apply_method = "immediate"
    }, {
    name         = "track_activity_query_size"
    value        = 16384
    apply_method = "pending-reboot"
    }, {
    name         = "idle_in_transaction_session_timeout"
    value        = 7200000
    apply_method = "immediate"
    }, {
    name         = "statement_timeout"
    value        = 7200000
    apply_method = "immediate"
    }, {
    name         = "apg_plan_mgmt.capture_plan_baselines"
    value        = "automatic"
    apply_method = "immediate"
    }, {
    name         = "apg_plan_mgmt.use_plan_baselines"
    value        = true
    apply_method = "immediate"
    }, {
    name         = "apg_plan_mgmt.plan_retention_period"
    value        = 90
    apply_method = "pending-reboot"
    }, {
    name         = "apg_plan_mgmt.unapproved_plan_execution_threshold"
    value        = 100
    apply_method = "immediate"
  }]

  mysql_cluster_pgroup_params = [{
    name         = "time_zone"
    value        = "UTC"
    apply_method = "immediate"
    }, {
    name         = "server_audit_logging"
    value        = 1
    apply_method = "immediate"
    }, {
    name         = "server_audit_events"
    value        = "QUERY_DCL,QUERY_DDL,CONNECT"
    apply_method = "immediate"
  }]

  mysql_db_pgroup_params = [{
    name         = "slow_query_log"
    value        = 1
    apply_method = "immediate"
    }, {
    name         = "long_query_time"
    value        = 10
    apply_method = "immediate"
    }, {
    name         = "innodb_print_all_deadlocks"
    value        = 1
    apply_method = "immediate"
  }]

  logs_set = compact([
    var.enable_audit_log && (var.engine != "aurora-postgresql") ? "audit" : "",
    var.enable_error_log && (var.engine != "aurora-postgresql") ? "error" : "",
    var.enable_general_log && (var.engine != "aurora-postgresql") ? "general" : "",
    var.enable_slowquery_log && (var.engine != "aurora-postgresql") ? "slowquery" : "",
    var.enable_postgresql_log && (var.engine == "aurora-postgresql") ? "postgresql" : "",
  ])
}   