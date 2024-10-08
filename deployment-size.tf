locals {
  # Specifications for t-shirt sized deployments
  deployment_size = {
    small = {
      db             = "db-n1-highmem-2",
      min_node_count = 2,
      max_node_count = 3,
      node_instance  = "n2-highmem-4"
      cache          = "6"
    },
    medium = {
      db             = "db-n1-highmem-4",
      min_node_count = 2,
      max_node_count = 4,
      node_instance  = "n2-highmem-4"
      cache          = "6"
    },
    large = {
      db             = "db-n1-highmem-8",
      min_node_count = 3,
      max_node_count = 4,
      node_instance  = "n2-highmem-8"
      cache          = "13"
    },
    xlarge = {
      db             = "db-n1-highmem-16",
      min_node_count = 3,
      max_node_count = 5,
      node_instance  = "n2-highmem-8"
      cache          = "13"
    },
    xxlarge = {
      db             = "db-n1-highmem-32",
      min_node_count = 3,
      max_node_count = 6,
      node_instance  = "n2-highmem-16"
      cache          = "26"
    }
  }
}
