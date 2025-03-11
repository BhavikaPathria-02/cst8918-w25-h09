provider "azurerm" {
  features {}
  subscription_id = "5fac1c80-5422-4c76-933d-a10e479aa38b"
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    min_count  = 1
    max_count  = 3
    auto_scaling_enabled = true  # Enable auto-scaling
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "development"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
