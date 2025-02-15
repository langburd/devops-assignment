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
    ingress_application_gateway_id = dependency.appgw.outputs.ingress_application_gateway_id
    location                       = include.root.locals.env_vars["location"]
    resource_group_name            = include.root.locals.env_vars["resource_group_name"]
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
    "../appgw",
  ]
}

dependency "vnet" {
  config_path = "../vnet"
  mock_outputs = {
    subnet_appgw_cidr = "192.168.1.1/24"
    subnet_appgw_id   = "mock-subnet-id"
  }
}

dependency "appgw" {
  config_path = "../appgw"
  mock_outputs = {
    ingress_application_gateway_id = "mock-appgw-id"
  }
}
