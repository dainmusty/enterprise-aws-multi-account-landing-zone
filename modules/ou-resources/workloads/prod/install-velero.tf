resource "helm_release" "velero" {
  provider = helm.prod

  name             = "velero"
  namespace        = "velero"
  create_namespace = true

  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  version          = "7.1.0"

  
  values = [
    file("${path.module}/values/velero-values.yaml")
  ]
}