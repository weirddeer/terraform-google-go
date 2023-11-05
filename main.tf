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

variable "service" {
  type        = string
  description = "The name of the service."
}

variable "stage" {
  type        = string
  description = "The stage to deploy to."
  default     = "dev"
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
  default     = "../service-account.json"
}

variable "service_account_email" {
  type        = string
  description = "The service account email to use."
}

provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}
