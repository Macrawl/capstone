terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

data "aws_eks_cluster" "my-eks" {
  name = "my-eks"
}
data "aws_eks_cluster_auth" "my_eks_auth" {
  name = "my_eks_auth"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.hr-dev-eks-demo.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.hr-dev-eks-demo.certificate_authority[0].data)
  version          = "2.16.1"
  config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "hr-dev-eks-demo"]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "k8s-namespace" {
  metadata {
    name = "sock-shop"
  }
}