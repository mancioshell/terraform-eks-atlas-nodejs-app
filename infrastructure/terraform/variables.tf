################################################################################
# Default Variables
################################################################################

variable "aws-region" {
  type    = string
  default = "us-east-1"
}

################################################################################
# EKS Cluster Variables
################################################################################

variable "cluster_name" {
  type    = string
  default = "eks-cluster"
}

################################################################################
# Atlas Cluster Variables
################################################################################

variable "atlas_org_id" {
  description = "Atlas organization id"
  type        = string
  sensitive   = true
}
variable "atlas_public_key" {
  description = "Public API key to authenticate to Atlas"
  type        = string
  sensitive   = true
}
variable "atlas_private_key" {
  description = "Private API key to authenticate to Atlas"
  type        = string
  sensitive   = true
}

variable "atlas_db_username" {
  description = "Database username for MongoDB Atlas"
  type        = string
  sensitive   = true
}

variable "atlas_db_password" {
  description = "Database password for MongoDB Atlas"
  type        = string
  sensitive   = true
}

variable "atlas_project_name" {
  description = "Atlas project name"
  default     = "prod"
  type        = string
}
variable "atlas_cluster_name" {
  description = "Atlas cluster name"
  default     = "nodejs-cluster"
  type        = string
}
variable "atlas_cluster_type" {
  description = "Atlas cluster TYPE"
  default     = "REPLICASET"
  type        = string
}
variable "atlas_provider_name" {
  description = "Atlas cluster provider name"
  default     = "TENANT"
  type        = string
}
variable "atlas_backing_provider_name" {
  description = "Atlas cluster backing provider name"
  default     = "AWS"
  type        = string
}

variable "atlas_provider_instance_size_name" {
  description = "Atlas cluster provider instance name"
  default     = "M0"
  type        = string
}

################################################################################
# ALB Controller Variables
################################################################################

variable "env_name" {
  type    = string
  default = "dev"
}