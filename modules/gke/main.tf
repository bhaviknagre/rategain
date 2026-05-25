resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network_name
  subnetwork = var.subnet_name

  # We can't create a cluster with no node pool defined, but we want to immediately delete it
  # to use a separate managed node pool.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_ip_range_name
    services_secondary_range_name = var.service_ip_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Keep control plane public for ease of setup/admin access
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Enable Shielded GKE Nodes
  enable_shielded_nodes = true

  lifecycle {
    ignore_changes = [
      ip_allocation_policy,
    ]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count
  project    = var.project_id

  node_config {
    preemptible  = false
    machine_type = var.machine_type

    # Google recommends custom service accounts for nodes rather than the default compute SA.
    # For simplification, we will use default but recommend custom in production.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
