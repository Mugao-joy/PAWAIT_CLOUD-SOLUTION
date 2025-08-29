# Service account used by Cloud Run runtime
resource "google_service_account" "run_sa" {
  account_id   = "insight-agent-run-sa"
  display_name = "Insight Agent Cloud Run runtime SA"
  project      = var.project_id
}

# Give runtime SA permission to read from Artifact Registry
resource "google_project_iam_member" "run_sa_artifactreader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

# Give runtime SA logging & monitoring write perms (common best practice)
resource "google_project_iam_member" "run_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "run_sa_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}
