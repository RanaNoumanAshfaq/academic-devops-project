resource "azurerm_resource_group" "aks_rg" {
  name     = "${var.project_name}-aks-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${var.project_name}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    # Cost Optimization: "Standard_B2s" is cheap and good for demos
    vm_size    = "Standard_B2s" 
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Academic"
  }
}