#provider
variable "subscription_id" {
    type = string
}

variable "client_id" {
    type = string
}

variable "client_secret" {
    type = string
}

variable "tenant_id" {
    type = string
}

#resource group
variable "my-resources" {
  type = string
}
variable "West Europe" {
  type = string
}

#network
variable "NSG-network" { 
}
variable "address_space" {
    type = list(string)
}
variable "subnet1" {
  
}
variable "subnet_address" {
    type = string
  
}
variable "subnet2" { 
}
variable "subnet2_address" {
    type = string
  
}
