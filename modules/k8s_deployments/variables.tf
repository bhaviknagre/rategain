variable "namespace" {
  description = "The target Kubernetes namespace for these deployments"
  type        = string
  default     = "infra"
}

variable "elasticsearch_chart_version" {
  description = "The version of the Elasticsearch Helm chart to deploy"
  type        = string
  default     = "7.17.3" # Stable chart version
}