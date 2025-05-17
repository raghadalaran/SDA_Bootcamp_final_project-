
terraform {

  backend "azurerm" {
    resource_group_name  = "Devops1-week12-Techmomentum-Storge-RG"
    storage_account_name = "techmomentumstorage"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
  

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }

  #   tls = {
  #    source  = "hashicorp/tls"
  #    version = "4.0.6"
  #  }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "tls" {

}

