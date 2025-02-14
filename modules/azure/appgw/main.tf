terraform {
  required_version = ">= 1.5.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "< 4.20"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "pip" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name              = "${lower(var.resource_group_name)}-appgw-pip"
  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}

locals {
  backend_address_pool_name      = try("${var.vnet_name}-beap", "")
  frontend_ip_configuration_name = try("${var.vnet_name}-feip", "")
  frontend_port_name_80          = try("${var.vnet_name}-feport80", "")
  # frontend_port_name_443         = try("${var.vnet_name}-feport443", "")
  http_setting_name         = try("${var.vnet_name}-be-htst", "")
  listener_name             = try("${var.vnet_name}-httplstn", "")
  request_routing_rule_name = try("${var.vnet_name}-rqrt", "")
}

resource "azurerm_application_gateway" "appgw" {
  resource_group_name = var.resource_group_name
  location            = var.location

  #checkov:skip=CKV_AZURE_120:We don't need the WAF for this simple example
  name = "${lower(var.resource_group_name)}-appgw"

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    cookie_based_affinity = "Disabled"
    name                  = local.http_setting_name
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  frontend_port {
    name = local.frontend_port_name_80
    port = 80
  }

  #   frontend_port {
  #     name = local.frontend_port_name_443
  #     port = 443
  #   }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.subnet_appgw_id
  }

  http_listener {
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_80
    name                           = local.listener_name
    protocol                       = "Http"
  }

  #   http_listener {
  #     frontend_ip_configuration_name = local.frontend_ip_configuration_name
  #     frontend_port_name             = local.frontend_port_name_443
  #     name                           = local.listener_name
  #     protocol                       = "Https"
  #     ssl_certificate_name           = var.ssl_certificate_name
  #   }

  request_routing_rule {
    http_listener_name         = local.listener_name
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1
  }

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      redirect_configuration,
      request_routing_rule,
      ssl_certificate,
      tags,
      url_path_map,
    ]
  }

  tags = var.tags
}
