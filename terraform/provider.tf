terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  alias   = "google_global"
  project = "learngcp-xxxxx"
  region  = "northamerica-northeast2"
  # zone    = "northamerica-northeast2-a"
  default_labels = {
    "data-classification" : "internal"
  }
}
