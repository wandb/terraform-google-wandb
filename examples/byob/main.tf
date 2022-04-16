provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 13.0"
  project_id                  = null
  disable_dependent_services  = false
  disable_services_on_destroy = false
  activate_apis = [
    "pubsub.googleapis.com",  // File Storage
    "storage.googleapis.com", // Cloud Storage
  ]
}

module "resources" {
  source = "../../modules/file_storage"

  namespace = var.namespace
  labels    = var.labels

  bucket_location = "US"

  create_queue        = false
  deletion_protection = true
}

resource "google_storage_bucket_iam_member" "object_admin" {
  bucket = module.resource.bucket_name
  member = "serviceAccount:${var.service_account_email}"
  role   = "roles/storage.objectAdmin"
}

output "bucket_name" {
  value = module.resources.bucket_name
}