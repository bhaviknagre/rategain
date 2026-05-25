resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_id
  description                 = "Dataset for Motherduck migrated data"
  location                    = var.region
  project                     = var.project_id
  default_table_expiration_ms = 3600000 * 24 * 365 # 1 year default

  labels = {
    env = "production"
  }
}

resource "google_bigquery_table" "table" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = var.table_id
  project    = var.project_id

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "production"
  }

  schema = <<EOF
[
  {
    "name": "id",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Unique identifier"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED",
    "description": "The event timestamp"
  },
  {
    "name": "data",
    "type": "JSON",
    "mode": "NULLABLE",
    "description": "Raw payload data"
  }
]
EOF
}
