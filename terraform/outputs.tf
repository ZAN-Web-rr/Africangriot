# Output values after Terraform apply

output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.africangriot.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.africangriot.name
}

output "bucket_name" {
  description = "Name of the GCS bucket for uploads"
  value       = google_storage_bucket.uploads.name
}

output "bucket_url" {
  description = "URL of the GCS bucket"
  value       = google_storage_bucket.uploads.url
}

output "project_id" {
  description = "Google Cloud Project ID"
  value       = var.project_id
}

output "region" {
  description = "Deployment region"
  value       = var.region
}

output "image_url" {
  description = "Current container image URL"
  value       = var.image_url
}
