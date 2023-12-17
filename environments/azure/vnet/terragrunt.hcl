terraform {
  source = "${include.root.locals.resource_vars["tf_source"]}"
}

include "root" {
  path   = "${find_in_parent_folders()}"
  expose = true
}

inputs = merge(
  include.root.locals.resource_vars["inputs"],
  {
    resource_group_name = include.root.locals.env_vars["resource_group_name"]
    location            = include.root.locals.env_vars["location"]
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
  ]
}
