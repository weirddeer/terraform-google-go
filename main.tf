terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0"
    }
  }
}

variable "region" {
  type        = string
  description = "The region to deploy to."
  default     = "europe-west2"
}

variable "project" {
  type        = string
  description = "The project ID to deploy to."
}

variable "credentials" {
  type        = string
  description = "The path to the credentials file."
  default     = "../creds.json"
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}
