output "database_password_secret_name" {
  description = "The full resource name of the database password secret"
  value       = google_secret_manager_secret.database_password.id
}

output "database_password_secret_id" {
  description = "The secret ID of the database password"
  value       = google_secret_manager_secret.database_password.secret_id
}

output "database_password_secret_version" {
  description = "The version of the database password secret"
  value       = google_secret_manager_secret_version.database_password.version
  sensitive   = true
}
