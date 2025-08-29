output "cloud_run_service_name" {
  value = google_cloud_run_v2_service.insight.name
}

output "image_deployed" {
  value = var.image
}

output "cloud_run_uri" {
  value       = try(google_cloud_run_v2_service.insight.uri, "")
  description = "The externally visible URI for the Cloud Run service (may be empty for internal-only services)"
}
