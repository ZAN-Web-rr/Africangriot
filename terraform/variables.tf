# Input variables for African Griot Blog infrastructure

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  default     = "zarnite-web"
}

variable "region" {
  description = "Google Cloud region for resources"
  type        = string
  default     = "europe-west1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "africangriot"
}

variable "image_url" {
  description = "Container image URL"
  type        = string
  default     = "europe-west1-docker.pkg.dev/zarnite-web/cloud-run-source-deploy/africangriot/africangriot:latest"
}

variable "cpu_limit" {
  description = "CPU limit for Cloud Run service"
  type        = string
  default     = "1000m"
}

variable "memory_limit" {
  description = "Memory limit for Cloud Run service"
  type        = string
  default     = "512Mi"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = string
  default     = "1"
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = string
  default     = "1"
}

variable "container_concurrency" {
  description = "Maximum concurrent requests per container"
  type        = number
  default     = 80
}

variable "timeout_seconds" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
  default     = "ZAN-Web-rr"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "Africangriot"
}
