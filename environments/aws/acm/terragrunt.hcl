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
    app_name         = include.root.locals.common_vars["app_name"]
    hosted_zone_id   = dependency.route53_zone.outputs.hosted_zone_id
    hosted_zone_name = include.root.locals.common_vars["hosted_zone_name"]
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
    "../route53_zone",
  ]
}

dependency "route53_zone" {
  config_path = "../route53_zone"
  mock_outputs = {
    hosted_zone_id = "Z1234567890"
  }
}
