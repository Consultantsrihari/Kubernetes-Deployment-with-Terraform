resource "kubernetes_service" "example" {
  
  metadata {
    name = "terraform-service"
    namespace = kubernetes_namespace.namespace-k8s.id
  }
  spec {
    selector = {
      test = "my-terraform-demo"
    }
    port {
      port        = 3000
      target_port = 3000
      
    }

    type = "NodePort"
  }
}

