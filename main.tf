# http://pac.zscaler.net/g5djBylT8zsl/PAC_ChromeOS_Decathlon
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.9.0"
    }
    ovh = {
      source = "ovh/ovh"
      version = "0.16.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.5.0"
    }
    argocd = {
      source = "oboukili/argocd"
      version = "3.0.0"
    }
  }
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = "IfgYXAWtC0eZCUSe"
  application_secret = "KIwBm9sUJV5VaISmiPE2BBmJ9vdD3T0I"
  consumer_key       = "4ILb2SBa43x8nV4PU0eRGa75TyF9oZDH"
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

provider "argocd" {
  server_addr = "127.0.0.1:8080"
  username = "admin"
  password = "admin"
}

# Kubernetes Managed Service
resource "ovh_cloud_project_kube" "icekubes" {
  service_name = "de9eaa1e9cc94734bf787165a68f4d01"
  name         = "icekubes"
  region       = "GRA5"
  version      = "1.22"
}

resource "ovh_cloud_project_kube_nodepool" "d24" {
  service_name  = "de9eaa1e9cc94734bf787165a68f4d01"
  kube_id       = ovh_cloud_project_kube.icekubes.id
  name          = "d24"
  flavor_name   = "d2-4"
  desired_nodes = 1
  max_nodes     = 3
  min_nodes     = 1
  autoscale     = true 
}

resource "local_file" "kubeconfig" {
  content  = ovh_cloud_project_kube.icekubes.kubeconfig
  filename = "etc/kube/ovh.yaml"
}

resource "argocd_project" "pastis-hosting" {
  metadata {
    name      = "pastis-hosting"
    namespace = "ph-argocd"
  }

  spec {
    description  = "Pastis Hosting"
    source_repos = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }
    cluster_resource_blacklist {
      group = "*"
      kind  = "*"
    }
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRoleBinding"
    }
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRole"
    }
    namespace_resource_blacklist {
      group = "networking.k8s.io"
      kind  = "Ingress"
    }
    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "kubernetes_namespace" "ph-argocd" {
  metadata {
    annotations = {
      name = "ph-argocd"
    }

    name = "ph-argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "./src/applications/enabled/argocd"
  namespace  = kubernetes_namespace.ph-argocd.metadata[0].annotations.name
  timeout    = 1800
}
