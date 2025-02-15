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
    tags = merge(
      include.root.locals.resource_vars.inputs.tags,
      include.root.locals.env_vars["tags"],
      include.root.locals.common_vars["tags"]
    )
  },
)
