################################################################################
# MongoDB Atlas Cluster Module
################################################################################

module "atlas_cluster" {
  source = "./modules/atlas-cluster"

  atlas_org_id      = var.atlas_org_id
  atlas_public_key  = var.atlas_public_key
  atlas_private_key = var.atlas_private_key

  atlas_db_username = var.atlas_db_username
  atlas_db_password = var.atlas_db_password

  project_name                 = var.atlas_project_name
  cluster_name                 = var.atlas_cluster_name
  cluster_type                 = var.atlas_cluster_type
  provider_name                = var.atlas_provider_name
  backing_provider_name        = var.atlas_backing_provider_name
  backing_provider_region_name = var.aws-region
  provider_instance_size_name  = var.atlas_provider_instance_size_name

  vpc_id = module.vpc.vpc_id
}