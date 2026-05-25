variable "project_id" {
  description = "The GCP project ID to deploy resources"
  type        = string
}

variable "region" {
  description = "The primary GCP region for resources"
  type        = string
  default     = "us-central1"
}

# VPC variables
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_name" {
  description = "The name of the primary subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for primary subnet"
  type        = string
}

variable "pod_ip_cidr_range" {
  description = "Secondary CIDR range for GKE Pods"
  type        = string
}

variable "service_ip_cidr_range" {
  description = "Secondary CIDR range for GKE Services"
  type        = string
}

# GKE variables
variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "gke_node_count" {
  description = "Number of GKE nodes"
  type        = number
  default     = 1
}

variable "gke_min_node_count" {
  description = "Minimum number of GKE nodes for autoscaling"
  type        = number
  default     = 1
}

variable "gke_max_node_count" {
  description = "Maximum number of GKE nodes for autoscaling"
  type        = number
  default     = 5
}

# Artifact Registry variables
variable "artifact_registry_id" {
  description = "The ID of the Artifact Registry repository"
  type        = string
}

# Cloud SQL variables
variable "db_primary_instance_name" {
  description = "Primary Cloud SQL instance name"
  type        = string
}

variable "db_replica_instance_name" {
  description = "Replica Cloud SQL instance name"
  type        = string
}

variable "db_tier" {
  description = "Machine tier for Cloud SQL instances"
  type        = string
  default     = "db-g1-small"
}

variable "db_name" {
  description = "Name of default database"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "database_password_secret_id" {
  description = "Secret ID for storing database password in Secret Manager"
  type        = string
  default     = "postgresql-password"
}

# BigQuery variables
variable "bigquery_dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
}

variable "bigquery_table_id" {
  description = "BigQuery table ID"
  type        = string
}

# Firestore variables
variable "firestore_region" {
  description = "Firestore database location ID"
  type        = string
  default     = "nam5"
}

# Redis variables
variable "redis_instance_name" {
  description = "Redis instance name"
  type        = string
}

variable "redis_tier" {
  description = "Redis instance tier"
  type        = string
  default     = "BASIC"
}

variable "redis_memory_size_gb" {
  description = "Redis memory size in GB"
  type        = number
  default     = 1
}

# Pub/Sub variables
variable "pubsub_topic_name" {
  description = "Pub/Sub topic name"
  type        = string
}

variable "pubsub_subscription_name" {
  description = "Pub/Sub subscription name"
  type        = string
}

# GCS variables
variable "gcs_bucket_name" {
  description = "GCS bucket name"
  type        = string
}
