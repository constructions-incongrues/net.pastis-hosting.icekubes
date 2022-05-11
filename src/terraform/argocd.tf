provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth.0.cluster_ca_certificate,
    )
    client_certificate = google_container_cluster.primary.master_auth.0.client_certificate
    client_key         = google_container_cluster.primary.master_auth.0.client_key
  }
}

resource "kubernetes_namespace" "ph-sealed-secrets" {
  metadata {
    annotations = {
      name = "ph-sealed-secrets"
    }
    name = "ph-sealed-secrets"
  }

  depends_on = [
    google_container_node_pool.primary_nodes
  ]
}

resource "kubernetes_namespace" "ph-argocd" {
  metadata {
    annotations = {
      name = "ph-argocd"
    }
    name = "ph-argocd"
  }

  depends_on = [
    google_container_node_pool.primary_nodes
  ]
}


resource "helm_release" "sealed-secrets" {
  name              = "sealed-secrets"
  chart             = "../applications/enabled/sealed-secrets"
  namespace         = kubernetes_namespace.ph-sealed-secrets.metadata[0].annotations.name
  timeout           = 1800
  atomic            = true
  dependency_update = true
}

resource "helm_release" "argocd" {
  name              = "argocd"
  chart             = "../applications/enabled/argocd"
  namespace         = kubernetes_namespace.ph-argocd.metadata[0].annotations.name
  timeout           = 1800
  atomic            = true
  dependency_update = true
  depends_on = [
    helm_release.sealed-secrets
  ]
}


# provider "argocd" {
#   server_addr = "argocd.pastis-hosting.net:443"
#   username = "admin"
#   password = "nP6g0EFp2am9OP8n"
#   plain_text = true
#   port_forward = true
#   port_forward_with_namespace = "ph-argocd"
# }

# resource "argocd_project" "pastis-hosting" {
#   metadata {
#     name      = "pastis-hosting"
#     namespace = "ph-argocd"
#   }

#   spec {
#     description  = "Pastis Hosting"
#     source_repos = ["*"]

#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = "*"
#     }
#     cluster_resource_blacklist {
#       group = "*"
#       kind  = "*"
#     }
#     cluster_resource_whitelist {
#       group = "rbac.authorization.k8s.io"
#       kind  = "ClusterRoleBinding"
#     }
#     cluster_resource_whitelist {
#       group = "rbac.authorization.k8s.io"
#       kind  = "ClusterRole"
#     }
#     namespace_resource_blacklist {
#       group = "networking.k8s.io"
#       kind  = "Ingress"
#     }
#     namespace_resource_whitelist {
#       group = "*"
#       kind  = "*"
#     }
#   }
# }
