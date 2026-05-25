# Secret Manager Module - Centralized secrets management

resource "google_secret_manager_secret" "database_password" {
  project   = var.project_id
  secret_id = var.database_password_secret_id

  labels = {
    env      = "production"
    purpose  = "database"
    resource = "postgresql"
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "database_password" {
  secret      = google_secret_manager_secret.database_password.id
  secret_data = var.database_password
}

# IAM binding: Allow GKE service account to access database password secret
resource "google_secret_manager_secret_iam_member" "database_password_gke" {
  secret_id = google_secret_manager_secret.database_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.gke_service_account}"
}

# IAM binding: Allow migration service account to access database password secret
resource "google_secret_manager_secret_iam_member" "database_password_migration" {
  count     = var.migration_service_account != null ? 1 : 0
  secret_id = google_secret_manager_secret.database_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.migration_service_account}"
}
