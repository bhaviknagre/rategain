variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The location for the Firestore database (e.g., nam5 for US multi-region, or a specific region)"
  type        = string
  default     = "nam5"
}

variable "database_name" {
  description = "The name of the Firestore database, usually '(default)'"
  type        = string
  default     = "(default)"
}
