# providers.tf for dev environment
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.52.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "6dbc33a2-5da4-4090-8ac2-b8dde7d2a834"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "tfstatebackend123"   # must be globally unique
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

# az group create -n rg-terraform-backend -l Centralindia
# az storage account create -n tfstatebackend1235 -g rg-terraform-backend -l eastus --sku Standard_LRS
# az storage container create --name tfstate --account-name tfstatebackend1235
