variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "gke_node_service_account_id" {
  description = "ID of the GKE node service account"
  type        = string
  default     = "gke-nodes"
}

variable "migration_service_account_id" {
  description = "ID of the migration service account"
  type        = string
  default     = "migration-jobs"
}

variable "observability_service_account_id" {
  description = "ID of the observability service account"
  type        = string
  default     = "observability"
}

variable "application_service_account_id" {
  description = "ID of the application service account"
  type        = string
  default     = "applications"
}
