terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
}

data "aws_elb_hosted_zone_id" "this" {}

data "aws_lb" "app" {
  name = var.app_name
}

# DNS records for application
resource "aws_route53_record" "app" {
  zone_id = var.hosted_zone_id
  name    = var.app_name
  type    = "A"
  # ttl     = 300
  # records = [data.dns_a_record_set.alb.addrs[0], var.public_ip_address]
  alias {
    name                   = data.aws_lb.app.dns_name
    zone_id                = data.aws_elb_hosted_zone_id.this.id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "azure" {
  zone_id = var.hosted_zone_id
  name    = "${var.app_name}-azure"
  type    = "A"
  ttl     = 300
  records = [var.public_ip_address]
}
