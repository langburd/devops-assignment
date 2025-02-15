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
    app_environment     = include.root.locals.env_vars.tags["Environment"]
    app_name            = "${include.root.locals.common_vars["app_name"]}-azure"
    cluster_name        = dependency.aks.outputs.cluster_name
    hosted_zone_name    = include.root.locals.common_vars["hosted_zone_name"]
    location            = include.root.locals.env_vars["location"]
    resource_group_name = include.root.locals.env_vars["resource_group_name"]
  },
)

dependencies {
  paths = [
    "../rg",
    "../aks",
    "../agic",
    "../cert_manager",
  ]
}

dependency "aks" {
  config_path = "../aks"
  mock_outputs = {
    cluster_name = "test-cluster"
  }
}
