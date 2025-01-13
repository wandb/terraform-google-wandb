output "bucket_name" {
  value = module.bucket.bucket_name
}

output "bucket_queue_name" {
  value = var.create_queue ? module.pubsub.0.queue_name : null
}
