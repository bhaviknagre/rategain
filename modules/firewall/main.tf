# Firewall Module - Network security with deny-all-by-default

# Default DENY ALL ingress (lowest priority = applied last)
resource "google_compute_firewall" "deny_all_ingress" {
  name      = "${var.vpc_name}-deny-all-ingress"
  network   = var.vpc_network_name
  priority  = 65534
  direction = "INGRESS"
  project   = var.project_id

  deny {
    protocol = "all"
  }
}

# Allow internal VPC traffic (10.0.0.0/8)
resource "google_compute_firewall" "allow_internal" {
  name      = "${var.vpc_name}-allow-internal"
  network   = var.vpc_network_name
  priority  = 1000
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/8"]
}

# Allow Google Cloud health checks for load balancers
resource "google_compute_firewall" "allow_health_checks" {
  name      = "${var.vpc_name}-allow-health-checks"
  network   = var.vpc_network_name
  priority  = 1001
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

# Allow IAP (Identity-Aware Proxy) for secure admin access
resource "google_compute_firewall" "allow_iap_tunnel" {
  name      = "${var.vpc_name}-allow-iap-tunnel"
  network   = var.vpc_network_name
  priority  = 1002
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]  # SSH and RDP for bastion
  }

  source_ranges = ["35.235.240.0/20"]  # Google's IAP range
}

# Allow GKE nodes to communicate with control plane
resource "google_compute_firewall" "allow_gke_control_plane" {
  name      = "${var.vpc_name}-allow-gke-control-plane"
  network   = var.vpc_network_name
  priority  = 1003
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["10250"]  # kubelet API
  }

  allow {
    protocol = "tcp"
    ports    = ["10255"]  # kubelet read-only port (optional)
  }

  source_ranges = ["172.16.0.0/28"]  # GKE control plane CIDR (from GKE config)
}

# Allow DNS (required for all pods)
resource "google_compute_firewall" "allow_dns" {
  name      = "${var.vpc_name}-allow-dns"
  network   = var.vpc_network_name
  priority  = 1004
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  source_ranges = ["10.0.0.0/8"]
}

# Enable VPC Flow Logs for network monitoring
resource "google_compute_network" "vpc_with_flow_logs" {
  count                   = var.enable_flow_logs ? 1 : 0
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_logging_project_sink" "vpc_flow_logs" {
  count           = var.enable_flow_logs ? 1 : 0
  name            = "${var.vpc_name}-flow-logs"
  destination     = "logging.googleapis.com/projects/${var.project_id}/logs/vpc-flow-logs"
  filter          = "resource.type=\"gce_subnetwork\""
  project         = var.project_id
  unique_writer_identity = true
}

# Allow external HTTPS traffic for ingress (if needed)
resource "google_compute_firewall" "allow_https_ingress" {
  count     = var.allow_external_https ? 1 : 0
  name      = "${var.vpc_name}-allow-https-ingress"
  network   = var.vpc_network_name
  priority  = 1100
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Allow external HTTP traffic for ingress (if needed)
resource "google_compute_firewall" "allow_http_ingress" {
  count     = var.allow_external_http ? 1 : 0
  name      = "${var.vpc_name}-allow-http-ingress"
  network   = var.vpc_network_name
  priority  = 1101
  direction = "INGRESS"
  project   = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
