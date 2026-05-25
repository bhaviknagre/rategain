output "database_name" {
  description = "The name of the Firestore database"
  value       = google_firestore_database.database.name
}

output "database_uid" {
  description = "The unique ID of the Firestore database"
  value       = google_firestore_database.database.uid
}
