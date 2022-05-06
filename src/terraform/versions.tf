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

    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
    
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.13.0"
    }
  }
}
