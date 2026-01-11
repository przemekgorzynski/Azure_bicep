// This module must be deployed into a resource group
// Pass scope when calling module from main.bicep

param vnetName string
param vnetAddressPrefix string
param location string

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

output vnetId string = vnet.id
output vnetResource object = vnet
output vnetName string = vnet.name
output vnetLocation string = vnet.location
