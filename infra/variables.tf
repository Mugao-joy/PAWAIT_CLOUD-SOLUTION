variable "project_id" {
  description = "GCP project id where resources will be created"
  type        = string
}

variable "region" {
  description = "GCP region (also used for Artifact Registry location)"
  type        = string
  default     = "us-central1"
}

variable "artifact_repo_name" {
  description = "Artifact Registry repository id (docker)"
  type        = string
  default     = "insight-agent-repo"
}

variable "cloud_run_service_name" {
  description = "Cloud Run service name"
  type        = string
  default     = "insight-agent"
}

variable "image" {
  description = "Container image (full Artifact Registry URI) to deploy"
  type        = string
  default     = ""
}

# Principals allowed to invoke the Cloud Run service (list of members, e.g. ["serviceAccount:sa@project.iam.gserviceaccount.com"])
variable "invoker_principals" {
  description = "A list of members to grant run.invoker (kept empty for tight default)"
  type        = list(string)
  default     = []
}
