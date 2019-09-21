variable "sid" {
  default = "groupc"
}

variable "cid" {
  default = "groupc"
}

variable "cs" {
  default = "groupc"
}

variable "tid" {
  default = "groupc"
}

provider "azurerm" {
    subscription_id = "${var.sid}"
    client_id       = "${var.cid}"
    client_secret   = "${var.cs}"
    tenant_id       = "${var.tid}"
}

variable "prefix" {
  default = "groupc"
}


resource "azurerm_resource_group" "azure_rg" {
  name     = "${var.prefix}-rg"
  location = "westus2"
}

resource "azurerm_storage_account" "azure_sa" {
  name                     = "${var.prefix}funcappsa"
  resource_group_name      = "${azurerm_resource_group.azure_rg.name}"
  location                 = "${azurerm_resource_group.azure_rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "azure_app_service_plan" {
  name                = "${var.prefix}-app-service-plan"
  location            = "${azurerm_resource_group.azure_rg.location}"
  resource_group_name = "${azurerm_resource_group.azure_rg.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "azure_function_app" {
  name                      = "${var.prefix}-azure-function"
  location                  = "${azurerm_resource_group.azure_rg.location}"
  resource_group_name       = "${azurerm_resource_group.azure_rg.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.azure_app_service_plan.id}"
  storage_connection_string = "${azurerm_storage_account.azure_sa.primary_connection_string}"
}
