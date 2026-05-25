output "gke_node_service_account_email" {
  description = "Email of the GKE node service account"
  value       = google_service_account.gke_nodes.email
}

output "gke_node_service_account_name" {
  description = "Name of the GKE node service account"
  value       = google_service_account.gke_nodes.account_id
}

output "migration_service_account_email" {
  description = "Email of the migration service account"
  value       = google_service_account.migration.email
}

output "observability_service_account_email" {
  description = "Email of the observability service account"
  value       = google_service_account.observability.email
}

output "application_service_account_email" {
  description = "Email of the application service account"
  value       = google_service_account.application.email
}
