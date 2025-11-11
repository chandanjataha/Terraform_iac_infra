vms = {
  vms1 = {
    resource_group_name             = "dev-rg-01"
    location                        = "central india"
    virtual_network_name            = "todo-vnet-01"
    subnet_name                     = "todo-vnet-01"
    pip_name                        = "pip"
    allocation_method               = "Static"
    address_space                   = ["10.0.0.0/16"]
    address_prefixes                = ["10.0.2.0/26"]
    nic_name                        = "dev-nic-01"
    ip_name                         = "internal"
    vm_name                         = "frontendvm"
    size                            = "Standard_F2"
    admin_username                  = "adminuser"
    admin_password                  = "Password@123"
    disable_password_authentication = false
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
    publisher                       = "Canonical"
    offer                           = "0001-com-ubuntu-server-jammy"
    sku                             = "22_04-lts"
    version                         = "latest"
    # name_ip_configuration           = "internal"
    # subnet_id                     = azurerm_subnet.subnet[each.key].id
    # private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.pip[each.key].id

  }
}
