# IAM Module - Custom service accounts and roles with least-privilege access

# GKE Node Service Account (replaces default compute service account)
resource "google_service_account" "gke_nodes" {
  project      = var.project_id
  account_id   = var.gke_node_service_account_id
  display_name = "GKE Node Service Account"
  description  = "Custom service account for GKE nodes with minimal permissions"
}

# Migration Service Account
resource "google_service_account" "migration" {
  project      = var.project_id
  account_id   = var.migration_service_account_id
  display_name = "Migration Service Account"
  description  = "Service account for data migration jobs"
}

# Observability Service Account
resource "google_service_account" "observability" {
  project      = var.project_id
  account_id   = var.observability_service_account_id
  display_name = "Observability Service Account"
  description  = "Service account for monitoring and logging"
}

# Application Service Account
resource "google_service_account" "application" {
  project      = var.project_id
  account_id   = var.application_service_account_id
  display_name = "Application Service Account"
  description  = "Service account for application workloads"
}

# --- GKE Node Service Account Roles ---
resource "google_project_iam_member" "gke_nodes_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_cloud_trace" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_cloud_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_gcr_reader" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# --- Migration Service Account Roles ---
resource "google_project_iam_member" "migration_cloudsql_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"
  member  = "serviceAccount:${google_service_account.migration.email}"
}

resource "google_project_iam_member" "migration_dataflow_admin" {
  project = var.project_id
  role    = "roles/dataflow.admin"
  member  = "serviceAccount:${google_service_account.migration.email}"
}

resource "google_project_iam_member" "migration_bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.migration.email}"
}

resource "google_project_iam_member" "migration_gcs_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.migration.email}"
}

resource "google_project_iam_member" "migration_dms_admin" {
  project = var.project_id
  role    = "roles/clouddms.admin"
  member  = "serviceAccount:${google_service_account.migration.email}"
}

resource "google_project_iam_member" "migration_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.migration.email}"
}

# --- Observability Service Account Roles ---
resource "google_project_iam_member" "observability_monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.observability.email}"
}

resource "google_project_iam_member" "observability_logging_logwriter" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.observability.email}"
}

resource "google_project_iam_member" "observability_cloudtrace_agent" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.observability.email}"
}

# --- Application Service Account Roles ---
resource "google_project_iam_member" "application_gcs_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.application.email}"
}

resource "google_project_iam_member" "application_pubsub_editor" {
  project = var.project_id
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.application.email}"
}

resource "google_project_iam_member" "application_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.application.email}"
}
