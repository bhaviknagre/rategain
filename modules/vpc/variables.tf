variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the subnet"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "The primary CIDR range for the subnet"
  type        = string
}

variable "pod_ip_cidr_range" {
  description = "The secondary CIDR range for GKE Pods"
  type        = string
}

variable "service_ip_cidr_range" {
  description = "The secondary CIDR range for GKE Services"
  type        = string
}
