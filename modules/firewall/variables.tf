variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "vpc_network_name" {
  description = "The self_link of the VPC network"
  type        = string
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for network monitoring"
  type        = bool
  default     = true
}

variable "allow_external_https" {
  description = "Allow external HTTPS traffic (0.0.0.0/0)"
  type        = bool
  default     = false
}

variable "allow_external_http" {
  description = "Allow external HTTP traffic (0.0.0.0/0)"
  type        = bool
  default     = false
}
