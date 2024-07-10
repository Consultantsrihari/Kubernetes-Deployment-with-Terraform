resource "kubernetes_horizontal_pod_autoscaler_v1" "my_hpa" {
  metadata {
    name      = "k8s-terraform-hpa"
    namespace = kubernetes_namespace.namespace-k8s.id
  }

  spec {
    max_replicas = 6
    min_replicas = 2

    target_cpu_utilization_percentage = 80

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.priyanshu_deployment.metadata[0].name
    }
  }
}