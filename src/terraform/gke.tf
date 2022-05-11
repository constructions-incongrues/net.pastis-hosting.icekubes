variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "gke_machine_type" {
  default     = "n1-standard-1"
  description = "number of gke nodes"
}

variable "gke_cluster_location" {
  description = "gke cluster location"
}

# GCP project
resource "google_project_service" "cloudresourcemanager" {
  project                    = var.project_id
  service                    = "cloudresourcemanager.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudbilling" {
  project                    = var.project_id
  service                    = "cloudbilling.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "serviceusage" {
  project                    = var.project_id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  project                    = var.project_id
  service                    = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "compute" {
  project                    = var.project_id
  service                    = "compute.googleapis.com"
  disable_dependent_services = true
}

# GKE cluster
resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = "${var.project_id}-gke"
  location = var.gke_cluster_location
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  initial_node_count       = 1
  remove_default_node_pool = true

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.gke_cluster_location
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  project    = var.project_id
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  depends_on = [
    google_project_service.container
  ]

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = var.gke_machine_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "google_service_account" "k10-agent" {
  project      = var.project_id
  account_id   = "k10-agent"
  display_name = "k10-agent"
}

resource "google_project_iam_member" "compute" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.k10-agent.email}"
}

resource "google_project_iam_member" "container" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.k10-agent.email}"
}

resource "google_service_account_key" "k10-agent" {
  service_account_id = google_service_account.k10-agent.name
}
