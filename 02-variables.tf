variable "project_id" {
  type        = string
  description = "Your GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "authorized_user" {
  type        = string
  description = "Email address of authorized user for secured doc e.g. user@gmail.com"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name"
}