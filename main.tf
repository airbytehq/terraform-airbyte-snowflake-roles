terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.73.0"
      configuration_aliases = [ snowflake.securityadmin, snowflake.sysadmin]
    }
  }
}

resource "snowflake_role" "airbyte" {
  provider = snowflake.securityadmin
  name = var.airbyte_role
}

resource "snowflake_role_grants" "sysadmin_grants" {
  provider = snowflake.securityadmin
  role_name = snowflake_role.airbyte.name
  roles = ["SYSADMIN"]
}

resource "snowflake_user" "airbyte_user" {
  provider = snowflake.securityadmin
  name = var.airbyte_username
  password = var.airbyte_password
  default_role = snowflake_role.airbyte.name
  default_warehouse = var.airbyte_warehouse_name
}

resource "snowflake_role_grants" "user_grant" {
  provider = snowflake.securityadmin
  role_name = snowflake_role.airbyte.name

  users = [
    snowflake_user.airbyte_user.name
  ]
}

resource "snowflake_grant_privileges_to_role" "ab_warehouse_grant" {
  provider = snowflake.sysadmin
  privileges = ["USAGE"]
  role_name = snowflake_role.airbyte.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.airbyte_warehouse_name
  }
}

resource "snowflake_grant_privileges_to_role" "ab_db_grant" {
  provider = snowflake.sysadmin
  privileges = ["OWNERSHIP"]
  role_name = snowflake_role.airbyte.name
  on_account_object {
    object_type = "DATABASE"
    object_name = var.airbyte_database_name
  }
}

resource "snowflake_grant_privileges_to_role" "ab_aschema_grant" {
  for_each = toset(var.airbyte_schema_names)
  provider = snowflake.sysadmin
  privileges = ["OWNERSHIP"]
  role_name = snowflake_role.airbyte.name
  on_schema {
    all_schemas_in_database = var.airbyte_database_name
  }
}
