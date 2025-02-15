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
    resource_group_name = include.root.locals.env_vars["resource_group_name"]
    location            = include.root.locals.env_vars["location"]
    vnet_name           = dependency.vnet.outputs.vnet_name
    subnet_appgw_id     = dependency.vnet.outputs.subnet_appgw_id
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
  ]
}

dependency "vnet" {
  config_path = "../vnet"
  mock_outputs = {
    vnet_name       = "vnet"
    subnet_appgw_id = "subnet-appgw"
  }
}
