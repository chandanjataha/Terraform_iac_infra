variable "vms" {}
# variable "ip_configuration" {}

resource "azurerm_resource_group" "rgs" {
  for_each = var.vms
  name     = each.value.resource_group_name
  location = each.value.location
}
resource "azurerm_virtual_network" "vnet" {
  depends_on = [ azurerm_resource_group.rgs ]
  for_each = var.vms

  name                = each.value.virtual_network_name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}
resource "azurerm_public_ip" "pip" {
  depends_on = [ azurerm_resource_group.rgs ]
  for_each = var.vms
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method

  tags = {
    environment = "dev"
  }
}


resource "azurerm_subnet" "subnet" {
  depends_on = [ azurerm_virtual_network.vnet ]
  for_each             = var.vms
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_interface" "nic" {
  depends_on = [ azurerm_subnet.subnet ]
  for_each            = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  depends_on = [ azurerm_network_interface.nic ]
  for_each                        = var.vms
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = each.value.disable_password_authentication
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]



  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}
