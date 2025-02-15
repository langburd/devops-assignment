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
    cluster_name                     = dependency.aks.outputs.cluster_name
    ingress_application_gateway_name = dependency.appgw.outputs.ingress_application_gateway_name
    location                         = include.root.locals.env_vars["location"]
    resource_group_name              = include.root.locals.env_vars["resource_group_name"]
    subnet_appgw_name                = dependency.vnet.outputs.subnet_appgw_name
  },
  {
    tags = merge(
      include.root.locals.env_vars["tags"],
      include.root.locals.common_vars["tags"]
    )
  },
)

dependencies {
  paths = [
    "../rg",
    "../vnet",
    "../aks",
    "../appgw",
  ]
}

dependency "vnet" {
  config_path = "../vnet"
  mock_outputs = {
    subnet_appgw_name = "test-subnet-appgw"
  }
}

dependency "appgw" {
  config_path = "../appgw"
  mock_outputs = {
    ingress_application_gateway_name = "test-appgw"
  }
}

dependency "aks" {
  config_path = "../aks"
  mock_outputs = {
    cluster_name = "test-cluster"
  }
}
