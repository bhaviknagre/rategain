output "service_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.default.uri
}

output "service_account_email" {
  description = "The email of the custom Cloud Run service account"
  value       = google_service_account.cloud_run.email
}
