
terraform {

  backend "azurerm" {
    resource_group_name  = "Devops1-week12-Techmomentum-rg"
    storage_account_name = "techmomentumstorage"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }

  

}

provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "a7135c8f-934c-4000-b5b1-b09d6b645365"

}

