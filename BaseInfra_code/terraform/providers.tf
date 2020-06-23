

provider "azurerm" {
  client_secret   = "wznXKPY70b64rnjZTn=NhMqOnAuVl@=]"
  subscription_id = "34d9e027-3f29-417d-be50-fd75c0472242"
  tenant_id       = "b9fec68c-c92d-461e-9a97-3d03a0f18b82"
  client_id       = "b2573f9c-e97c-425f-973b-0b873f259f21"
  features {}

}



# Azure AD Provider
provider "azuread" {

  client_secret   = "wznXKPY70b64rnjZTn=NhMqOnAuVl@=]"
  subscription_id = "34d9e027-3f29-417d-be50-fd75c0472242"
  tenant_id       = "b9fec68c-c92d-461e-9a97-3d03a0f18b82"
  client_id       = "b2573f9c-e97c-425f-973b-0b873f259f21"


}


