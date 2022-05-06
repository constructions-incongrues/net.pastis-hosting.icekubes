variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

provider "google" {
  # project = var.project_id
  region  = var.region
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${google_project.ph.project_id}-vpc"
  auto_create_subnetworks = "false"
  project                 = google_project.ph.project_id
  depends_on = [
    google_project_service.compute
  ]
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${google_project.ph.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
  project       = google_project.ph.project_id

  depends_on = [
    google_project_service.compute
  ]
}