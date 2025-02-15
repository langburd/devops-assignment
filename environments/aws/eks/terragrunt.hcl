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
    subnet_ids = dependency.vpc.outputs.public_subnet_ids
  },
  {
    tags = merge(
      include.root.locals.resource_vars.inputs.tags,
      include.root.locals.env_vars["tags"],
      include.root.locals.common_vars["tags"]
    )
  },
)

dependencies {
  paths = [
    "../vpc",
  ]
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    public_subnet_ids = ["dummy_public_subnet_id1", "dummy_public_subnet_id2"]
  }
}
