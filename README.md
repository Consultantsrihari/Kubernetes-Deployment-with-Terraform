# Deploying React Application in Kubernetes cluster with Horizontal Pod Autoscaler using Terraform
 
 
In this project, I will harness the power of Terraform and Kubernetes to deploy a React application with a Horizontal Pod Autoscaler (HPA) for efficient workload management. By integrating IaC with Kubernetes, I can automate and optimize the deployment process, ensuring scalability and reliability.


Infrastructure as Code (IaC) uses files or code to manage IT infrastructure, eliminating the need for manual configuration. This approach addresses key challenges like management, cost, scalability, availability, and discrepancies. IaC, particularly with a declarative approach, allows specifying the desired state rather than the steps to achieve it, simplifying code writing and speeding up deployments.

Terraform, a popular IaC tool, has been instrumental in infrastructure management for nearly a decade. Its compatibility with various providers and modules allows for extensive integrations. Combining Terraform with other DevOps tools aligns with the principles of automation and continuous integration/continuous deployment (CI/CD).

Kubernetes, or k8s, is an open-source container orchestration platform that automates the deployment, management, and scaling of containerized applications. It simplifies container management, making it a go-to solution for modern application deployment.

React Application: — You can check the code for the React Application and Dockerfile from Consultantsrihari/Docker-React

Setting Up providers
Terraform came up with the Kubernetes provider which helps in integrating it with the k8s cluster, Providers are essential for letting Terraform know with whom it is going to work.

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
   config_path    = "D:\gitrepos\Kubernets-deployment-Terraform\.kube\config"
}
In the Kubernetes provider, add the config path for the config file.


Creating Namespace
Namespace in Kubernetes is a way to organize clusters into separate virtual clusters. The below code will help you to create the namespace.

resource "kubernetes_namespace" "namespace-k8s"{
    metadata {
        name = "my-namespace"
    }
}
metadata block contains a name to uniquely identify the Kubernetes namespace.


Creating Deployment
Deployment in Kubernetes is a crucial component through which we can implement strategy in our cluster. The below code takes the namespace as the namespace we created above by using the terraform way of passing dependencies. Labels help to uniquely identify the deployment. This deployment has 3 replicas when the initial deployment is created.

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
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          
        }
      }
    }
  }
}
template block takes the details about the replica configuration and the pod’s ports section maintains the port at which the container is listening( for react it’s 3000). You can add other deployment keywords based on your application setup.


Creating Service
Service in Kubernetes is a logical group of abstraction of pods in the cluster. It enables network access to the set of pods underneath it, here labels will work with the selector, to know which pods to abstract.

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

Creating Horizontal Pod Autoscaler
The Horizontal Pod Autoscaler is in charge of maintaining the cluster shape by increasing or decreasing the number of pods in the deployment in response to the workload’s CPU or memory consumption. Horizontal means increasing the pods rather than increasing the size of the pods resources which is expensive and not reliable. Here we are taking CPU utilization percentage as our standard for autoscaling.

The below code will help you to create the hpa for the setup:

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
In the metadata block name and namespace define the hpa identity and location in the k8s cluster. The spec section takes max and min replicas as the parameters to define the maximum and minimum number of pods scaling which this hpa can do.


The scale_target_ref block takes the details about the kind of resource the hpa has to look for and the name for it.

All the components are done. Let’s start the final step with Terraform init !!

Terraform init
To initialize the working directory and download the provider.

terraform init

Terraform plan
To get the blueprint for the terraform deployment structure to know before applying.

terraform plan

Terraform apply
After checking the output of the plan command run the apply command to complete the setup.

terraform apply
After the apply command runs successfully, use kubectl commands to check the resources that you just created.

kubectl get pods -n my-namespace
kubectl get svc -n my-namesapce
kubectl get hpa -n my-namespace
Here is the React Quote application that you just deployed using Terraform and Kubernetes.


Clean Up
To finish up the resources use the terraform destroy command to delete the whole setup in one go.

terraform destroy

Github Code: https://github.com/Consultantsrihari/Kubernetes-Deployment-with-Terraform

Conclusion
In the above blog, we were able to successfully deploy a react app in the Kubernetes cluster, if you want to know more about Terraform and its integration

%%%%%% Thanks %%%%%%
