output "snowflake_role" {
  value = snowflake_role.airbyte
  description = "Snowflake Airbyte Role Resource"
}

output "snowflake_user" {
  value = snowflake_user.airbyte_user
  description = "Snowflake Airbyte User Resource"
}

