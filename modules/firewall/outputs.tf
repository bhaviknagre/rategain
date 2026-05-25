output "deny_all_rule_name" {
  description = "Name of the deny-all firewall rule"
  value       = google_compute_firewall.deny_all_ingress.name
}

output "allow_internal_rule_name" {
  description = "Name of the allow-internal firewall rule"
  value       = google_compute_firewall.allow_internal.name
}

output "firewall_rules" {
  description = "Map of all firewall rule names"
  value = {
    deny_all           = google_compute_firewall.deny_all_ingress.name
    allow_internal     = google_compute_firewall.allow_internal.name
    allow_health_check = google_compute_firewall.allow_health_checks.name
    allow_iap          = google_compute_firewall.allow_iap_tunnel.name
    allow_gke_cp       = google_compute_firewall.allow_gke_control_plane.name
    allow_dns          = google_compute_firewall.allow_dns.name
  }
}
