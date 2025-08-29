# Insight-Agent — Serverless API on GCP (Cloud Run) with Terraform + GitHub Actions

## Overview
Insight-Agent is a small FastAPI service that exposes `POST /analyze` and returns a simple analysis of word & character counts.  
This repo demonstrates a secure, automated deployment to Google Cloud Run (serverless) using Terraform for infra and GitHub Actions with OIDC for CI/CD.

Architecture (text diagram):
Developer (GitHub) --(push)--> GitHub Actions --build/push--> Artifact Registry --(Terraform)--> Cloud Run (internal-only)

GCP services used:
- Artifact Registry (docker) — stores images.
- Cloud Run (Gen2) — serverless container runtime. Ingress set to internal-only. 
- IAM & Service Accounts — least privilege for CI and runtime.
- (Optional) Cloud Build — not used directly here, but APIs enabled.

## Design Decisions
- **FastAPI + Uvicorn**: small, easy to containerize and test locally.
- **Cloud Run**: serverless, autoscaling, minimal infra for MVP. Easier than GKE for a single HTTP service.
- **Artifact Registry**: maintain private container registry inside the project.
- **Workload Identity Federation (OIDC)**: GitHub Actions use short-lived tokens to authenticate with GCP — avoids committing service account keys.
- **Ingress = internal-only + IAM**: service is not publicly reachable; invocations require appropriate identity/permissions.

## Setup & Deploy (step-by-step)
1. **Prereqs**
   - GCP project with billing enabled (or use existing project).
   - `gcloud`, `docker`, `terraform` installed locally for testing.
   - GitHub repo (push code to `main` to trigger pipeline).

2. **Enable APIs locally**  
   
   Terraform also enables the APIs when applied.

3. **Create a Workload Identity Pool & Provider** (one-time, from a machine with GCP owner rights)
- Create pool & provider

4. **Create a service account for CI impersonation**
Grant it the minimal roles:
Adjust per least privilege needs.

5. **Wire the pool/provider to allow GitHub repo OIDC**
After this, add repo secrets:
- `WORKLOAD_IDENTITY_PROVIDER` (full provider resource id)
- `GCP_SA_EMAIL` (e.g. `gha-deployer@project.iam.gserviceaccount.com`)
- `GCP_PROJECT_ID` (the project id)

6. **Create files** (app, Dockerfile, terraform files, GH workflow). See files in this repo.

7. **Push to `main`** → GitHub Actions will:
- authenticate via OIDC
- build image and push to Artifact Registry
- run `terraform apply -var="image=<artifact-registry-uri:sha>"` to update Cloud Run

## Testing the deployed service
- Cloud Run is internal-only. To invoke:
- From a VM in same VPC, or
- Use a caller identity with `roles/run.invoker` and request an ID token:
 ```
 TOKEN=$(gcloud auth print-identity-token)
 curl -H "Authorization: Bearer $TOKEN" -X POST -d '{"text":"hello world"}' -H "Content-Type: application/json" https://<cloud-run-uri>/analyze
 ```




