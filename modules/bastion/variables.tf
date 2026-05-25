variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy the Bastion VM"
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy the Bastion VM"
  type        = string
  default     = ""
}

variable "network_id" {
  description = "The VPC network ID"
  type        = string
}

variable "subnet_id" {
  description = "The VPC subnet ID where the VM will reside"
  type        = string
}

variable "subnet_cidr" {
  description = "The subnet CIDR range to advertise as route in Tailscale"
  type        = string
}

variable "tailscale_secret_id" {
  description = "The GSM secret ID for the Tailscale Auth Key"
  type        = string
}

variable "sftp_password_secret_id" {
  description = "The GSM secret ID for the SFTP user password"
  type        = string
}

variable "sftp_ssh_key_secret_id" {
  description = "The GSM secret ID for the SFTP SSH public key"
  type        = string
}
