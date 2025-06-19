################################################################################
# Cluster
################################################################################

output "standard_srv" {
    description = "The standard SRV connection string for the MongoDB Atlas cluster"
    value = module.atlas_cluster.standard_srv
}