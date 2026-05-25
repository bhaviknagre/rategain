variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "database_password_secret_id" {
  description = "Secret ID for database password in Secret Manager"
  type        = string
  default     = "postgresql-password"
}

variable "database_password" {
  description = "Database password - will be stored in Secret Manager"
  type        = string
  sensitive   = true
}

variable "gke_service_account" {
  description = "GKE node service account email for secret access"
  type        = string
}

variable "migration_service_account" {
  description = "Migration service account email for secret access (optional)"
  type        = string
  default     = null
}
