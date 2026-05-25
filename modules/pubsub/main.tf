resource "google_pubsub_topic" "topic" {
  name    = var.topic_name
  project = var.project_id

  labels = {
    env = "production"
  }
}

resource "google_pubsub_subscription" "subscription" {
  name    = var.subscription_name
  topic   = google_pubsub_topic.topic.name
  project = var.project_id

  # 20 minutes acknowledgment deadline
  ack_deadline_seconds = 20

  labels = {
    env = "production"
  }
}
