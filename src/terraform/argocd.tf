resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "./src/applications/enabled/argocd"
  namespace  = kubernetes_namespace.ph-argocd.metadata[0].annotations.name
  timeout    = 1800
}

resource "kubernetes_namespace" "ph-argocd" {
  metadata {
    annotations = {
      name = "ph-argocd"
    }

    name = "ph-argocd"
  }
}

# provider "argocd" {
#   server_addr = "argocd.local:443"
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

# resource "helm_release" "argocd" {
#   name       = "argocd"
#   chart      = "./src/applications/enabled/argocd"
#   namespace  = kubernetes_namespace.ph-argocd.metadata[0].annotations.name
#   timeout    = 1800
# }
