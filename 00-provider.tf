terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "acl-demo-tfstate-jv"  
    prefix = "acl-security-demo"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}