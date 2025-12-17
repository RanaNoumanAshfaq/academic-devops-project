variable "project_name" {
  description = "Base name for resources"
  type        = string
  default     = "academic-project"
}

# --- AWS Variables ---
variable "aws_region" {
  description = "AWS Region to deploy to"
  default     = "us-east-1"
}

variable "aws_vpc_cidr" {
  description = "CIDR block for AWS VPC"
  default     = "10.0.0.0/16"
}

# --- GCP Variables ---
variable "gcp_project_id" {
  description = "Your Google Cloud Project ID"
  type        = string
  # REPLACE THIS with your actual Project ID
  default     = "my-academic-project-id" 
}

variable "gcp_region" {
  default = "us-central1"
}