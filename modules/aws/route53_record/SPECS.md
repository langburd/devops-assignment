# route53_record

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.azure](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_elb_hosted_zone_id.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_hosted_zone_id) | data source |
| [aws_lb.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The name of the app | `string` | `"app"` | no |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | The ID of the hosted zone | `string` | n/a | yes |
| <a name="input_public_ip_address"></a> [public\_ip\_address](#input\_public\_ip\_address) | The public IP address of the Application Gateway | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
