data "google_client_config" "provider" {}

provider "kubernetes" {
  host     = "https://${google_container_cluster.primary.endpoint}"
  token    = data.google_client_config.provider.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth.0.cluster_ca_certificate,
  )
  client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
  client_key             = google_container_cluster.primary.master_auth.0.client_key
}
