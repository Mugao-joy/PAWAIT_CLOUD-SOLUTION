# Grant roles/run.invoker to each principal in var.invoker_principals
resource "google_cloud_run_v2_service_iam_binding" "invoker" {
  provider = google-beta

  for_each = { for idx, p in var.invoker_principals : idx => p }

  # resource name of the Cloud Run service
  name = "projects/${var.project_id}/locations/${var.region}/services/${google_cloud_run_v2_service.insight.name}"
  role = "roles/run.invoker"

  members = [each.value]
}
