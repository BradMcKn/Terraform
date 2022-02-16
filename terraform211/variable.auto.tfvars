#serivce principle creds

#resource group variables

resource_name = "BradM_RG"
location = "eastus"

#networking variables
demo_network_NSG = "Network_Security_Group"
network_name = "Hub_network"
address_space = ["10.0.0.0/16"]
subnet1 = "webservers"
subnet_address = "10.0.1.0/24"
subnet2 = "database"
subnet2_address = "10.0.2.0/24"
network_NSG = "Network_Security_Group"