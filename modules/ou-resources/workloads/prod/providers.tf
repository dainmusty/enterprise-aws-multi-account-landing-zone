terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws.prod, aws.prod_dr ]
    }

    helm = {
      source  = "hashicorp/helm"
      configuration_aliases = [ helm.prod ]
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      configuration_aliases = [ kubernetes.prod ]

  }
}
}