################################################################################
# Cluster
################################################################################

output "standard_srv" {
    description = "The standard SRV connection string for the MongoDB Atlas cluster"
    value = mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard_srv
}