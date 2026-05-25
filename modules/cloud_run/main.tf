# Enable Cloud Run Admin API
resource "google_project_service" "run" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
  project            = var.project_id
}

# Create a dedicated Service Account for Cloud Run
resource "google_service_account" "cloud_run" {
  account_id   = "${var.service_name}-sa"
  display_name = "Cloud Run Service Account for ${var.service_name}"
  project      = var.project_id
}

# Grant the Cloud Run Service Account Secret Accessor permission on the DB password secret
resource "google_secret_manager_secret_iam_member" "cloud_run_db_pass" {
  project   = var.project_id
  secret_id = var.db_password_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Create Cloud Run Service (v2)
resource "google_cloud_run_v2_service" "default" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.cloud_run.email

    containers {
      image = var.container_image

      env {
        name  = "DB_HOST"
        value = var.db_host
      }
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_id
            version = "latest"
          }
        }
      }
    }

    # Enable Direct VPC Egress
    vpc_access {
      network_interfaces {
        network    = var.network_id
        subnetwork = var.subnet_id
      }
      egress = "ALL_TRAFFIC"
    }
  }

  depends_on = [
    google_project_service.run,
    google_secret_manager_secret_iam_member.cloud_run_db_pass
  ]
}
