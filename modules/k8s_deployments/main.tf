resource "kubernetes_namespace_v1" "infra" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  version    = var.elasticsearch_chart_version
  namespace  = kubernetes_namespace_v1.infra.metadata[0].name

  values = [
    <<EOF
antiAffinity: "soft"
replicas: 1
minimumMasterNodes: 1
resources:
  requests:
    cpu: "500m"
    memory: "1Gi"
  limits:
    cpu: "1000m"
    memory: "2Gi"
EOF
  ]

  depends_on = [
    kubernetes_namespace_v1.infra
  ]
}