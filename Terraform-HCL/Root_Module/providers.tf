terraform {
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

  }

  subscription_id = "a7135c8f-934c-4000-b5b1-b09d6b645365"
}
