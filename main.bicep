targetScope = 'subscription'

param orgPrefix string
param regionSh string
param env string
param location string
param tags object
param vnetAddressPrefix string
param nsgSecurityRules array
param subnets array

var rgName = 'rg-${orgPrefix}-${env}-${regionSh}'
var vnetName = 'vnet-${orgPrefix}-${env}-${regionSh}'
var nsgName = 'nsg-${orgPrefix}-${env}-${regionSh}'
var networkWatcherName = 'netwatcher-${orgPrefix}-${env}-${regionSh}'


module rgModule './modules/rg.bicep' = {
  name: 'createResourceGroup'
  params: {
    rgName: rgName
    rgLocation: location
    tags: {
      Resource: 'Resource Group'
      ...tags
    }
  }
}

module networkWatcherModule './modules/networkWatcher.bicep' = {
  name: 'createNetworkWatcher'
  scope: resourceGroup(rgName)
  params: {
    networkWatcherName: networkWatcherName
    location: rgModule.outputs.location
    tags: {
      Resource: 'Network Watcher'
      ...tags
    }
  }
}

module vnetModule './modules/vnet.bicep' = {
  name: 'createVnet'
  scope: resourceGroup(rgName)
  params: {
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    location: rgModule.outputs.location
    tags: {
      Resource: 'Virtual Network'
      ...tags
    }
  }
}

module nsg './modules/nsg.bicep' = {
  name: 'nsgDeploy'
  scope: resourceGroup(rgName)
  params: {
    nsgName: nsgName
    location: rgModule.outputs.location
    securityRules: nsgSecurityRules
    tags: {
      Resource: 'Network Security Group'
      ...tags
    }
  }
  dependsOn: [
    vnetModule
  ]
}

module subnetModule './modules/subnet.bicep' = [for s in subnets: {
  name: 'createSubnet-${s.name}'
  scope: resourceGroup(rgName)
  params: {
    vnetName: vnetName
    subnetName: s.name
    subnetPrefix: s.prefix
    privateEndpointNetworkPolicies: s.privateEndpointNetworkPolicies
  }
  dependsOn: [
    vnetModule
  ]
}]
