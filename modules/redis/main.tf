resource "google_redis_instance" "redis" {
  name               = var.redis_instance_name
  tier               = var.tier
  memory_size_gb     = var.memory_size_gb
  region             = var.region
  project            = var.project_id
  authorized_network = var.authorized_network

  connect_mode = "PRIVATE_SERVICE_ACCESS"
}