variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The geographic location where the BigQuery dataset should reside"
  type        = string
  default     = "US"
}

variable "dataset_id" {
  description = "A unique ID for the BigQuery dataset"
  type        = string
}

variable "table_id" {
  description = "A unique ID for the BigQuery table"
  type        = string
}
