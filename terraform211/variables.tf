
#resource group variables

variable "resource_name" {
    type = string
}

variable "location" {
    type = string
}

variable "demo_network_NSG" {
    type = string
}

variable "network_name" {
    type = string
}

variable "address_space" {
    type = list(string)
}

variable "subnet1" {
    type = string
  
}

variable "subnet_address" {
    type = string
  
}

variable "subnet2" {
    type = string
  
}

variable "subnet2_address" {
    type = string
  
}

variable "linux2_username" {
    type = string
}

variable "linux2_password" {
    type = string
}

variable "linux2_PIP" {
    type = string
}

variable "network_NSG" {
    type = string
}

