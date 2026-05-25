resource "google_compute_global_address" "private_service_access" {
  name          = "${var.redis_instance_name}-psa-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.authorized_network
  project       = var.project_id
}

resource "google_service_networking_connection" "private_service_access" {
  network                 = var.authorized_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_service_access.name
  ]

  depends_on = [
    google_compute_global_address.private_service_access
  ]
}

resource "google_redis_instance" "redis" {
  name               = var.redis_instance_name
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  region             = var.region
  project            = var.project_id
  authorized_network = var.authorized_network

  connect_mode = "PRIVATE_SERVICE_ACCESS"

  depends_on = [
    google_service_networking_connection.private_service_access
  ]
}