resource "google_sql_database_instance" "primary" {
  name             = var.primary_instance_name
  database_version = var.db_version
  region           = var.region
  project          = var.project_id

  settings {
    tier = var.tier

    backup_configuration {
      enabled            = true
      binary_log_enabled = false # PostgreSQL uses Write-Ahead Logging (WAL), binary logging is for MySQL/MariaDB
    }

    ip_configuration {
      ipv4_enabled = true # We enable public IP but restrict access, or use Cloud SQL Auth Proxy
    }
  }

  deletion_protection = false # Set to true for production workloads
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

  # For read replicas, this points to the primary instance
  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled = true
    }
  }

  # Replica depends on primary master node
  depends_on = [
    google_sql_database_instance.primary
  ]

  deletion_protection = false
}
