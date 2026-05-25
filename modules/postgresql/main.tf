resource "google_compute_global_address" "private_db_access" {
  name          = "${var.primary_instance_name}-psa-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
  project       = var.project_id
}

resource "google_service_networking_connection" "private_db_access" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_db_access.name]

  depends_on = [google_compute_global_address.private_db_access]
}

resource "google_sql_database_instance" "primary" {
  name             = var.primary_instance_name
  database_version = var.db_version
  region           = var.region
  project          = var.project_id

  settings {
    tier = var.tier

    backup_configuration {
      enabled                        = true
      binary_log_enabled             = false
      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }

  deletion_protection = true

  depends_on = [google_service_networking_connection.private_db_access]
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.primary.name
  project  = var.project_id
}

resource "google_sql_user" "user" {
  name     = var.database_user
  instance = google_sql_database_instance.primary.name
  password = var.database_password
  project  = var.project_id
}

resource "google_sql_database_instance" "replica" {
  count            = var.enable_replica ? 1 : 0
  name             = var.replica_instance_name
  database_version = var.db_version
  region           = var.region
  project          = var.project_id

  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }

  deletion_protection = true

  depends_on = [
    google_sql_database_instance.primary,
    google_service_networking_connection.private_db_access
  ]
}
