terraform {
  required_version = ">= 1.2.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.60.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.60.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# google-beta provider is required for some Cloud Run v2 or Gen2 features
provider "google-beta" {
  project = var.project_id
  region  = var.region
}
