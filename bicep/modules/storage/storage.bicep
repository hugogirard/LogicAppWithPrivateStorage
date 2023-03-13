param location string
//param fileShareName string

var contentStorageAccountName = 'str${uniqueString(resourceGroup().id)}'

resource contentStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: contentStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'    
  }
  kind: 'StorageV2'
  properties: {
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        
      ]
    }
    supportsHttpsTrafficOnly: true
  }
}

// resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
//   name: '${contentStorageAccountName}/default/${toLower(fileShareName)}'
//   dependsOn: [
//     contentStorageAccount
//   ]
// }

output storageName string = contentStorageAccount.name
