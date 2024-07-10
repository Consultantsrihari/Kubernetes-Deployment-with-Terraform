terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
   config_path    = "D:\gitrepos\Kubernets-deployment-Terraform\.kube\config"
   
}
