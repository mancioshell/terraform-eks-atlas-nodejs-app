################################################################################
# Sensitive variables for MongoDB Atlas cluster module
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

################################################################################
# Non-sensitive variables for MongoDB Atlas cluster module
################################################################################

variable "project_name" {
  description = "Atlas project name"
  type        = string
}
variable "cluster_name" {
  description = "Atlas cluster name"
  type        = string
}
variable "cluster_type" {
  description = "Atlas cluster TYPE"
  type        = string
}
variable "provider_name" {
  description = "Atlas cluster provider name"
  type        = string
}
variable "backing_provider_name" {
  description = "Atlas cluster backing provider name"
  type        = string
}
variable "backing_provider_region_name" {
  description = "Atlas cluster backing provider region name"
  type        = string
}
variable "provider_instance_size_name" {
  description = "Atlas cluster provider instance name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the MongoDB Atlas cluster will be deployed"
  type        = string
}