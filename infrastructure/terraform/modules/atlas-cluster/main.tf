resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.atlas_org_id
}

resource "mongodbatlas_project_ip_access_list" "ip_access_list" {
  project_id = mongodbatlas_project.project.id
  cidr_block = "0.0.0.0/0"
  comment    = "cidr block for all IPs"
}

resource "mongodbatlas_cluster" "cluster" {
  project_id                  = mongodbatlas_project.project.id
  name                        = var.cluster_name
  cluster_type                = var.cluster_type
  provider_name               = var.provider_name
  backing_provider_name       = var.backing_provider_name
  provider_region_name        = var.backing_provider_region_name
  provider_instance_size_name = var.provider_instance_size_name
}

resource "mongodbatlas_database_user" "test" {
  username           = var.atlas_db_username
  password           = var.atlas_db_password
  project_id         = mongodbatlas_project.project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  scopes {
    name   = var.cluster_name
    type = "CLUSTER"
  }
}