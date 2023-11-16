variable "airbyte_role" {
  type = string
  default = "AIRBYTE_ROLE"
}

variable "airbyte_username" {
  type = string
  default = "AIRBYTE_USER"
}

variable "airbyte_warehouse_name" {
  type = string
  default = "AIRBYTE_WAREHOUSE"
}

variable "airbyte_database_name" {
  type = string
  default = "AIRBYTE_DATABASE"
}

variable "airbyte_password" {
  type = string
  sensitive = true
}
