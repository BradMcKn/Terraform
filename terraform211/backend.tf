terraform{
    backend "azurerm"{
        resource_group_name  = "BradM_RG"
        storage_account_name = "terraform32"
        container_name       = "newterra"
        key                  = "hybrid_IaC"
    }
}