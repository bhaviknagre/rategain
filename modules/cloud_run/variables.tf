variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy the Cloud Run service"
  type        = string
}

variable "service_name" {
  description = "The name of the Cloud Run service"
  type        = string
  default     = "app-service"
}

variable "container_image" {
  description = "The container image to deploy to Cloud Run"
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello:latest"
}

variable "network_id" {
  description = "The VPC network ID for Direct VPC Egress"
  type        = string
}

variable "subnet_id" {
  description = "The VPC subnetwork ID for Direct VPC Egress"
  type        = string
}

variable "db_host" {
  description = "The private host address of the PostgreSQL database"
  type        = string
}

variable "db_user" {
  description = "The database username"
  type        = string
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "db_password_secret_id" {
  description = "The GSM secret ID or name for the database password"
  type        = string
}
