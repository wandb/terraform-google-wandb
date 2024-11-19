output "filestream_topic_name" {
  value = google_pubsub_topic.filestream[0].name
}

output "filestream_gorilla_subscription_name" {
  value = google_pubsub_subscription.filestream-gorilla[0].name
}

output "filestream_project_id" {
  value = google_pubsub_topic.filestream[0].project
}

output "run_updates_shadow_topic_name" {
  value = google_pubsub_topic.run_updates_shadow[0].name
}

output "flat_run_fields_updater_subscription_name" {
  value = google_pubsub_subscription.flat_run_fields_updater[0].name
}

output "run_updates_shadow_project_id" {
  value = google_pubsub_topic.run_updates_shadow[0].project
}