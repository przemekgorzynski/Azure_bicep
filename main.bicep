targetScope = 'subscription'

param env string
param location string
param vnetAddressPrefix string
param subnetPrefix string
param subnetName string

var rgName = 'rg-${env}-${location}'
var vnetName = 'vnet-${env}-${location}'

module rgModule './modules/rg.bicep' = {
  name: 'createResourceGroup'
  params: {
    rgName: rgName
    rgLocation: location
  }
}

module vnetModule './modules/vnet.bicep' = {
  name: 'createVnet'
  scope: resourceGroup(rgName)
  params: {
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    location: rgModule.outputs.location
  }
}

module subnetModule './modules/subnet.bicep' = {
  name: 'subnetModule'
  scope: resourceGroup(rgName)
  params: {
    vnetName: 'vnet-${env}-${location}'
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    privateEndpointNetworkPolicies: 'Disabled'
  }
  dependsOn: [vnetModule]
}
