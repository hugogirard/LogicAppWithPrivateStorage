param location string = resourceGroup().location
param vnetName string = 'vnet-lgapp'
param virtualNetworkAddressPrefix string = '10.0.0.0/16'
param logicAppSubnetAddressPrefix string = '10.0.1.0/24'
param privateEndpointSubnetAddressPrefix string = '10.0.2.0/27'
//param fileShareName string = 'strp98'


module vnet 'modules/networking/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location 
    logicAppSubnetAddressPrefix: logicAppSubnetAddressPrefix
    privateEndpointSubnetAddressPrefix: privateEndpointSubnetAddressPrefix
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    vnetName: vnetName
  }
}

module storage 'modules/storage/storage.bicep' = {
  name: 'storage'
  params: {    
    location: location
  }
}

module privateEndpoint 'modules/networking/private.endpoint.bicep' = {
  name: 'privateendpoint'
  params: {
    contentStorageAccountName: storage.outputs.storageName
    location: location
    subnetId: vnet.outputs.subnetPeId
    vnetId: vnet.outputs.vnetId
  }
}

module workspace 'modules/monitoring/workspace.bicep' = {
  name: 'workspace'
  params: {
    location: location
  }
}

module logicApp 'modules/logicApp/logicApp.bicep' = {
  name: 'logicApp'
  params: {
    appInsightName: workspace.outputs.insightName
    location: location
    storageName: storage.outputs.storageName
    subnetId: vnet.outputs.subnetWebId
  }
}

