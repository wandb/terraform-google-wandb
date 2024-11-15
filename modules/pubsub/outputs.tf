output "filestream_topic_name" {
  value = google_pubsub_topic.filestream.name
}

output "filestream_gorilla_subscription_name" {
  value = google_pubsub_subscription.filestream-gorilla.name
}

output "filestream_project_id" {
  value = google_pubsub_topic.filestream.project
}

output "run_updates_v2_topic_name" {
  value = google_pubsub_topic.filestream.name
}

output "flat_run_fields_updater_v2_subscription_name" {
  value = google_pubsub_subscription.flat_run_fields_updater_v2.name
}

output "run_updates_v2_project_id" {
  value = google_pubsub_topic.filestream.project
}