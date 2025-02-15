terraform {
  source = "${include.root.locals.resource_vars["tf_source"]}"
}

include "root" {
  path   = "${find_in_parent_folders("root.hcl")}"
  expose = true
}

inputs = merge(
  include.root.locals.resource_vars["inputs"],
  {
    cluster_name        = dependency.aks.outputs.cluster_name
    resource_group_name = include.root.locals.env_vars["resource_group_name"]
  }
)

dependencies {
  paths = [
    "../rg",
    "../aks",
  ]
}

dependency "aks" {
  config_path = "../aks"
  mock_outputs = {
    cluster_name = "test-cluster"
  }
}
