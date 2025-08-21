locals {
  # Specifications for t-shirt sized deployments
  deployment_size = {
    small = {
      db               = "db-n1-highmem-2",
      min_node_count   = 2,
      max_node_count   = 8,
      node_instance    = "n2-highmem-8"
      cache            = "6"
      root_volume_size = 100
    },
    medium = {
      db               = "db-n1-highmem-4",
      min_node_count   = 2,
      max_node_count   = 8,
      node_instance    = "n2-highmem-16"
      cache            = "6"
      root_volume_size = 100
    },
    large = {
      db             = "db-n1-highmem-8",
      min_node_count = 3,
      max_node_count = 8,
      node_instance  = "n2-highmem-16"
      cache          = "13"
      root_volume_size = 256
    },
    xlarge = {
      db             = "db-n1-highmem-16",
      min_node_count = 3,
      max_node_count = 8,
      node_instance  = "n2-highmem-16"
      cache          = "13"
      root_volume_size = 256
    },
    xxlarge = {
      db             = "db-n1-highmem-32",
      min_node_count = 3,
      max_node_count = 8,
      node_instance  = "n2-highmem-16"
      cache          = "26"
      root_volume_size = 256
    }
  }
}
