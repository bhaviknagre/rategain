resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.region
  project       = var.project_id
  storage_class = var.storage_class

  uniform_bucket_level_access = true

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    condition {
      age = 90 # Move objects older than 90 days to Nearline, or delete them, etc.
    }
    action {
      type = "Delete"
    }
  }
}
