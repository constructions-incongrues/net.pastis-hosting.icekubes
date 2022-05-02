terraform {
  required_providers {
    argocd = {
      source = "oboukili/argocd"
      version = "3.0.1"
    }
    
    google = {
      source  = "hashicorp/google"
      version = "4.19.0"
    }
  }
}