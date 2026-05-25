# VPC Outputs
output "vpc_network_name" {
  description = "The name of the VPC network"
  value       = module.vpc.network_name
}

# GKE Outputs
output "gke_cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "gke_endpoint" {
  description = "The endpoint of the GKE cluster control plane"
  value       = module.gke.endpoint
}

# Artifact Registry Outputs
output "artifact_registry_url" {
  description = "The URL of the Artifact Registry repository"
  value       = module.artifact_registry.repository_url
}

# Cloud SQL PostgreSQL Outputs
output "postgresql_primary_ip" {
  description = "The public IP of the primary PostgreSQL instance"
  value       = module.postgresql.primary_ip_address
}

output "postgresql_primary_connection" {
  description = "The connection name of the primary PostgreSQL instance"
  value       = module.postgresql.primary_connection_name
}

output "postgresql_replica_ip" {
  description = "The public IP of the replica PostgreSQL instance"
  value       = module.postgresql.replica_ip_address
}

# BigQuery Outputs
output "bigquery_dataset_id" {
  description = "The ID of the BigQuery dataset"
  value       = module.bigquery.dataset_id
}

# Firestore Outputs
output "firestore_database_name" {
  description = "The name of the Firestore database"
  value       = module.firestore.database_name
}

# Redis Outputs
output "redis_host" {
  description = "The IP address of the Memorystore Redis instance"
  value       = module.redis.host
}

# Pub/Sub Outputs
output "pubsub_topic" {
  description = "The name of the Pub/Sub topic"
  value       = module.pubsub.topic_name
}

# GCS Outputs
output "gcs_bucket_url" {
  description = "The URL of the GCS bucket"
  value       = module.gcs.bucket_url
}
