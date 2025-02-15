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
    hosted_zone_name = include.root.locals.common_vars["hosted_zone_name"]
    tags = merge(
      include.root.locals.env_vars["tags"],
      include.root.locals.common_vars["tags"]
    )
  },
)
