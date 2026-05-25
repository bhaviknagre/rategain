variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the database"
  type        = string
}

variable "primary_instance_name" {
  description = "The name of the primary PostgreSQL instance"
  type        = string
}

variable "replica_instance_name" {
  description = "The name of the replica PostgreSQL instance"
  type        = string
}

variable "db_version" {
  description = "The database engine version"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "The tier for the primary and replica instances"
  type        = string
  default     = "db-g1-small"
}

variable "database_name" {
  description = "The name of the default database to create"
  type        = string
}

variable "database_user" {
  description = "The username for the default database user"
  type        = string
}

variable "database_password" {
  description = "The password for the default database user"
  type        = string
  sensitive   = true
}

variable "enable_replica" {
  description = "Whether to create a read replica"
  type        = bool
  default     = true
}

variable "network_id" {
  description = "The VPC network ID for private Cloud SQL"
  type        = string
}

