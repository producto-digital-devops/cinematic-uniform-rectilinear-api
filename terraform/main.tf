terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.18.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "primary" {
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.region}-${var.env}-cinematic"
  location = var.region
  tags     = var.tags
}

//## AZURE FUNCTION - MESSAGES
resource "azurerm_app_service_plan" "asp_func_urm" {
  name                = "asp-${var.region}-${var.env}-cinematic-urm"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  tags = var.tags
}
resource "azurerm_storage_account" "st_func_urm" {
  name                     = "st${var.region}${var.env}cinematicurm"
  location                 = var.region
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = var.tags
}
resource "azurerm_function_app" "func_urm" {
  name                       = "func-${var.region}-${var.env}-cinematic-urm"
  location                   = var.region
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.asp_func_urm.id
  storage_account_name       = azurerm_storage_account.st_func_urm.name
  storage_account_access_key = azurerm_storage_account.st_func_urm.primary_access_key
  https_only                 = true
  os_type                    = "linux"
  version                    = "~3"
  app_settings = {
      "WEBSITE_RUN_FROM_PACKAGE" = "1"
      "FUNCTIONS_WORKER_RUNTIME" = "python"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}