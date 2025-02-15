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
    app_environment  = include.root.locals.env_vars.tags["Environment"]
    app_name         = include.root.locals.common_vars["app_name"]
    certificate_arn  = dependency.acm.outputs.certificate_arn
    cluster_name     = dependency.eks.outputs.cluster_name
    hosted_zone_name = include.root.locals.common_vars["hosted_zone_name"]
  },
)

dependencies {
  paths = [
    "../eks",
    "../acm",
    "../alb",
  ]
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name = "test-cluster"
  }
}

dependency "acm" {
  config_path = "../acm"
  mock_outputs = {
    certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }
}
