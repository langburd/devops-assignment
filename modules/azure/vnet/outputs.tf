output "subnet_appgw_cidr" {
  description = "The CIDR of the AppGW subnet"
  value       = azurerm_subnet.appgw.address_prefixes[0]
}

output "subnet_appgw_id" {
  description = "The ID of the AppGW subnet"
  value       = azurerm_subnet.appgw.id
}

output "subnet_appgw_name" {
  description = "The name of the AppGW subnet"
  value       = azurerm_subnet.appgw.name

}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.app.name
}
