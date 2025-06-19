################################################################################
# General Variables from root module
################################################################################

variable "aws-region" {
  type    = string
}

variable "env_name" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

################################################################################
# Variables from other Modules
################################################################################

variable "vpc_id" {
  description = "VPC ID which Load balancers will be  deployed in"
  type = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN used for IRSA "
  type = string
}

variable "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  type = string
}

variable "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  type = string
}