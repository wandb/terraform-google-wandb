module "project_factory_project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 13.0"
  project_id                  = null
  disable_dependent_services  = false
  disable_services_on_destroy = false
  activate_apis = [
    "storage.googleapis.com", // Cloud Storage
  ]
}

module "resources" {
  source = "../../modules/storage"

  namespace = var.namespace
  labels    = var.labels

  bucket_location     = var.bucket_location
  deletion_protection = var.deletion_protection
  create_queue        = false

  service_account = { "email" : var.service_account_email }

  depends_on = [module.project_factory_project_services]
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = module.resources.bucket_name
  member = "serviceAccount:${var.service_account_email}"
  role   = "roles/storage.admin"
}

data "google_storage_bucket" "default" {
  name = module.resources.bucket_name
}
