resource "kubernetes_namespace" "namespace-k8s"{
    metadata {
        name = "my-namespace"
    }
}