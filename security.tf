resource "azurerm_network_security_group" "wazuh_demo" {
  name                = "wazuh_demo_sg"
  location            = azurerm_resource_group.wazuh_rg.location
  resource_group_name = azurerm_resource_group.wazuh_rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "demo"
  }
}

resource "azurerm_subnet_network_security_group_association" "agent_security" {
  subnet_id                 = azurerm_subnet.wazuh_agent.id
  network_security_group_id = azurerm_network_security_group.wazuh_demo.id
}

resource "azurerm_subnet_network_security_group_association" "siem_security" {
  subnet_id                 = azurerm_subnet.wazuh_siem.id
  network_security_group_id = azurerm_network_security_group.wazuh_demo.id
}
