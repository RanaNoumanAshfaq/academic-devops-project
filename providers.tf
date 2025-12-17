terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# AWS Provider (Uses your "aws configure" credentials)
provider "aws" {
  region = var.aws_region
}

# Azure Provider (Uses your "az login" credentials)
provider "azurerm" {
  features {}
}

# Google Provider (Uses your "gcloud auth application-default login")
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}