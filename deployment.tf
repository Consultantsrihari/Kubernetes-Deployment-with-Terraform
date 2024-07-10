resource "kubernetes_deployment_v1" "srihari_deployment" {
  metadata {
    name = "my-deployment"
    namespace = kubernetes_namespace.namespace-k8s.id
    labels = {
      test = "my-terraform-demo"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "my-terraform-demo"
      }
    }

    template {
      metadata {
        labels = {
          test = "my-terraform-demo"
        }
      }

      spec {
        container {
          image = "srihari9963/quote-app"
          name  = "my-terraform-demo"
          port{
            container_port = 3000
          }
          

        #   liveness_probe {
        #     http_get {
        #       path = "/"
        #       port = 3000

        #       http_header {
        #         name  = "X-Custom-Header"
        #         value = "Awesome"
        #       }
        #     }

        #     initial_delay_seconds = 3
        #     period_seconds        = 3
        #   }
        }
      }
    }
  }
}
