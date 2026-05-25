variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the registry"
  type        = string
}

variable "repository_id" {
  description = "The ID/Name of the Artifact Registry repository"
  type        = string
}

variable "format" {
  description = "The format of the repository (e.g. DOCKER, MAVEN, etc.)"
  type        = string
  default     = "DOCKER"
}
