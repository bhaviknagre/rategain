variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the GKE cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes per zone in the node pool"
  type        = number
  default     = 1
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 5
}

variable "machine_type" {
  description = "The machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_service_account" {
  description = "Service account email for GKE nodes"
  type        = string
}

variable "pod_ip_range_name" {
  description = "The name of the secondary IP range for pods"
  type        = string
  default     = "gke-pods"
}

variable "service_ip_range_name" {
  description = "The name of the secondary IP range for services"
  type        = string
  default     = "gke-services"
}
