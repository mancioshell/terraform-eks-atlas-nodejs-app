resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.atlas_org_id
}

resource "mongodbatlas_project_ip_access_list" "ip_access_list" {
  project_id = mongodbatlas_project.project.id
  cidr_block = "0.0.0.0/0"
  comment    = "cidr block for all IPs"
}

# resource "mongodbatlas_privatelink_endpoint" "pe_vpc" {
#   project_id    = mongodbatlas_project.project.id
#   provider_name = var.backing_provider_name
#   region        = upper(replace(var.backing_provider_region_name, "-", "_"))
# }

# resource "mongodbatlas_privatelink_endpoint_service" "pe_vpc_service" {
#   project_id          = mongodbatlas_privatelink_endpoint.pe_vpc.project_id
#   private_link_id     = mongodbatlas_privatelink_endpoint.pe_vpc.id
#   endpoint_service_id = var.vpc_id
#   provider_name       = var.backing_provider_name
# }

resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id   = mongodbatlas_project.project.id
  name         = var.cluster_name
  cluster_type = var.cluster_type

  replication_specs {
    region_configs {
      priority              = 1
      provider_name         = var.provider_name
      region_name           = upper(replace(var.backing_provider_region_name, "-", "_"))
      backing_provider_name = var.backing_provider_name
      electable_specs {
        instance_size = var.provider_instance_size_name
        node_count    = 3
      }
    }
  }

  # depends_on = [mongodbatlas_privatelink_endpoint_service.pe_vpc_service]
}

resource "mongodbatlas_database_user" "admin-user" {
  username           = var.atlas_db_username
  password           = var.atlas_db_password
  project_id         = mongodbatlas_project.project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  scopes {
    name = var.cluster_name
    type = "CLUSTER"
  }
}
