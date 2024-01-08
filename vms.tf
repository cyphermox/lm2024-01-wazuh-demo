resource "azurerm_network_interface" "siem_nic" {
  name                = "siem-nic"
  location            = azurerm_resource_group.wazuh_rg.location
  resource_group_name = azurerm_resource_group.wazuh_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wazuh_siem.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.siem_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "wazuh-siem" {
  name                = "wazuh"
  resource_group_name = azurerm_resource_group.wazuh_rg.name
  location            = azurerm_resource_group.wazuh_rg.location
  size                = "Standard_E2d_v5"
  admin_username      = "sysadmin"
  network_interface_ids = [
    azurerm_network_interface.siem_nic.id,
  ]

  admin_ssh_key {
    username   = "sysadmin"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "agent_nic" {
  name                = "agent-nic"
  location            = azurerm_resource_group.wazuh_rg.location
  resource_group_name = azurerm_resource_group.wazuh_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wazuh_agent.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.agent_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "wazuh-agent" {
  name                = "agent"
  resource_group_name = azurerm_resource_group.wazuh_rg.name
  location            = azurerm_resource_group.wazuh_rg.location
  size                = "Standard_D2d_v5"
  admin_username      = "sysadmin"
  network_interface_ids = [
    azurerm_network_interface.agent_nic.id,
  ]

  admin_ssh_key {
    username   = "sysadmin"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "siem_public_ip" {
  name                = "siem-public-ip"
  resource_group_name = azurerm_resource_group.wazuh_rg.name
  location            = azurerm_resource_group.wazuh_rg.location
  allocation_method   = "Static"

  tags = {
    environment = "demo"
  }
}

resource "azurerm_public_ip" "agent_public_ip" {
  name                = "agent-public-ip"
  resource_group_name = azurerm_resource_group.wazuh_rg.name
  location            = azurerm_resource_group.wazuh_rg.location
  allocation_method   = "Static"

  tags = {
    environment = "demo"
  }
}
