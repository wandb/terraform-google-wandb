resource "google_storage_bucket" "bufstream" {
  name          = "${substr(var.namespace, 0, 20)}-bufstream"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  labels = merge(var.labels, {
    role          = "bufstream-bucket"
    "customer-ns" = replace(var.namespace, "-cluster", "")
    cluster       = var.cluster_name
  })
}

resource "google_service_account" "bufstream" {
  account_id   = "${substr(var.namespace, 0, 20)}-bufstream"
  display_name = "Bufstream Service Account"
  project      = var.project_id
}

resource "google_service_account_iam_member" "bufstream_workload_identity" {
  service_account_id = google_service_account.bufstream.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.bufstream_namespace}/${var.bufstream_service_account}]"
}

resource "google_storage_bucket_iam_member" "bufstream_bucket_admin" {
  bucket = google_storage_bucket.bufstream.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bufstream.email}"
}
