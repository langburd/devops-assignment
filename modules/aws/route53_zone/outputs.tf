output "hosted_zone_id" {
  description = "The ID of the hosted zone"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "The name servers of the hosted zone"
  value       = aws_route53_zone.this.name_servers
}
