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
    cluster_name      = dependency.eks.outputs.cluster_name
    oidc_provider     = dependency.eks.outputs.oidc_provider
    oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
  },
)

dependencies {
  paths = [
    "../eks",
  ]
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name      = "test-cluster"
    oidc_provider     = "oidc.eks.us-east-1.amazonaws.com/id/12345678901234567890"
    oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/12345678901234567890"
  }
}
