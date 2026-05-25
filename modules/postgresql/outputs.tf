output "primary_connection_name" {
  description = "The connection name of the primary PostgreSQL instance"
  value       = google_sql_database_instance.primary.connection_name
}

output "primary_ip_address" {
  description = "The public IP address of the primary PostgreSQL instance"
  value       = google_sql_database_instance.primary.public_ip_address
}

output "replica_connection_name" {
  description = "The connection name of the replica PostgreSQL instance"
  value       = var.enable_replica ? google_sql_database_instance.replica[0].connection_name : null
}

output "replica_ip_address" {
  description = "The public IP address of the replica PostgreSQL instance"
  value       = var.enable_replica ? google_sql_database_instance.replica[0].public_ip_address : null
}
