resource "azurerm_resource_group" "wazuh_rg" {
  name     = "wazuh-demo"
  location = "Canada Central"

  tags = {
    environment = "demo"
    owner       = "cyphermox"
  }
}

resource "azurerm_virtual_network" "wazuh_vnet" {
  name                = "azcac-vnet"
  location            = azurerm_resource_group.wazuh_rg.location
  resource_group_name = azurerm_resource_group.wazuh_rg.name

  address_space = [
    "10.3.0.0/23"
  ]

  tags = {
    environment = "demo"
    owner       = "cyphermox"
  }
}

resource "azurerm_subnet" "wazuh_siem" {
  name                = "wazuh-siem"
  resource_group_name = azurerm_resource_group.wazuh_rg.name

  virtual_network_name = azurerm_virtual_network.wazuh_vnet.name

  private_endpoint_network_policies_enabled = false
  address_prefixes                          = ["10.3.0.0/24"]
}

resource "azurerm_subnet" "wazuh_agent" {
  name                = "wazuh-agent"
  resource_group_name = azurerm_resource_group.wazuh_rg.name

  virtual_network_name = azurerm_virtual_network.wazuh_vnet.name

  private_endpoint_network_policies_enabled = false
  address_prefixes                          = ["10.3.1.0/24"]
}
