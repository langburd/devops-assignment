terraform {
  required_version = ">= 1.5.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "app" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name          = "${lower(var.resource_group_name)}-vnet"
  address_space = ["10.43.0.0/16"]

  tags = var.tags
}

resource "azurerm_subnet" "app" {
  resource_group_name = var.resource_group_name

  name                 = "${lower(var.resource_group_name)}-subnet-app"
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.43.0.0/24"]
}

resource "azurerm_subnet" "appgw" {
  resource_group_name = var.resource_group_name

  name                 = "${lower(var.resource_group_name)}-subnet-gw"
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.43.1.0/24"]
}
