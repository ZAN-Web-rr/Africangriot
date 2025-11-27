# Terraform configuration for African Griot Blog on Google Cloud Run

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  # Optional: Configure remote state storage in Google Cloud Storage
  # backend "gcs" {
  #   bucket = "africangriot-terraform-state"
  #   prefix = "terraform/state"
  # }
}

# Configure the Google Cloud Provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "cloudrun" {
  service = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifactregistry" {
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Google Cloud Storage bucket for uploads (optional for future use)
resource "google_storage_bucket" "uploads" {
  name          = "${var.project_id}-africangriot-uploads"
  location      = var.region
  force_destroy = false
  
  uniform_bucket_level_access = true
  
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

# Make bucket publicly readable for uploaded images
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.uploads.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Cloud Run Service - Matching your deployed configuration
resource "google_cloud_run_service" "africangriot" {
  name     = var.service_name
  location = var.region
  
  metadata {
    annotations = {
      "run.googleapis.com/ingress"        = "all"
      "run.googleapis.com/ingress-status" = "all"
      "run.googleapis.com/client-name"    = "terraform"
    }
  }
  
  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"    = var.max_instances
        "autoscaling.knative.dev/minScale"    = var.min_instances
        "run.googleapis.com/startup-cpu-boost" = "true"
      }
      labels = {
        "managed-by" = "terraform"
      }
    }
    
    spec {
      container_concurrency = var.container_concurrency
      timeout_seconds       = var.timeout_seconds
      service_account_name  = "${var.project_id}-compute@developer.gserviceaccount.com"
      
      containers {
        image = var.image_url
        
        ports {
          name           = "http1"
          container_port = 8080
        }
        
        env {
          name  = "NODE_ENV"
          value = "production"
        }
        
        env {
          name  = "PORT"
          value = "8080"
        }
        
        env {
          name  = "MAX_FILE_SIZE"
          value = "5242880"
        }
        
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }
        
        startup_probe {
          timeout_seconds   = 240
          period_seconds    = 240
          failure_threshold = 1
          
          tcp_socket {
            port = 8080
          }
        }
      }
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  depends_on = [
    google_project_service.cloudrun
  ]
}

# Allow unauthenticated access
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.africangriot.name
  location = google_cloud_run_service.africangriot.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Artifact Registry Repository for Docker images
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "cloud-run-source-deploy"
  description   = "Docker repository for African Griot blog"
  format        = "DOCKER"
  
  depends_on = [
    google_project_service.artifactregistry
  ]
}

# Cloud Build Trigger for CI/CD from GitHub
resource "google_cloudbuild_trigger" "github_trigger" {
  name        = "africangriot-github-trigger"
  description = "Trigger build on push to main branch"
  location    = "global"
  
  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "^main$"
    }
  }
  
  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t", "${var.region}-docker.pkg.dev/${var.project_id}/cloud-run-source-deploy/africangriot/africangriot:$SHORT_SHA",
        "-t", "${var.region}-docker.pkg.dev/${var.project_id}/cloud-run-source-deploy/africangriot/africangriot:latest",
        "."
      ]
    }
    
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "--all-tags", "${var.region}-docker.pkg.dev/${var.project_id}/cloud-run-source-deploy/africangriot/africangriot"]
    }
    
    step {
      name       = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = [
        "run", "deploy", var.service_name,
        "--image", "${var.region}-docker.pkg.dev/${var.project_id}/cloud-run-source-deploy/africangriot/africangriot:$SHORT_SHA",
        "--region", var.region,
        "--platform", "managed",
        "--allow-unauthenticated",
        "--min-instances", var.min_instances,
        "--max-instances", var.max_instances,
        "--cpu", var.cpu_limit,
        "--memory", var.memory_limit
      ]
    }
    
    images = [
      "${var.region}-docker.pkg.dev/${var.project_id}/cloud-run-source-deploy/africangriot/africangriot:$SHORT_SHA",
      "${var.region}-docker.pkg.dev/${var.project_id}/cloud-run-source-deploy/africangriot/africangriot:latest"
    ]
  }
  
  depends_on = [
    google_project_service.cloudbuild,
    google_artifact_registry_repository.docker_repo
  ]
}
