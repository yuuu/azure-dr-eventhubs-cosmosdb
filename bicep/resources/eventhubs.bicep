param appName string
param environment string
param eventHubName string

var eventHubsNameSpaceName = toLower('${appName}EventHubs${environment}')
var eventHubsNameSpaceID = eventHubsNameSpace.id
var eventHubsNameSpaceSharedAccessKey = listKeys('${eventHubsNameSpaceID}/authorizationRules/RootManageSharedAccessKey', '2017-04-01').primaryKey

resource eventHubsNameSpace 'Microsoft.EventHub/namespaces@2018-01-01-preview' = {
  name: eventHubsNameSpaceName
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1 // TU(スループットユニット)の数
  }
  properties: {
    isAutoInflateEnabled: false // 自動拡張の無効化
    kafkaEnabled: true // Kafkaプロトコルの有効化
    zoneRedundant: true // ゾーン冗長の有効化
  }
  tags: {
    env: environment
  }
}

resource eventHubsNameSpaceName_sensor_values 'Microsoft.EventHub/namespaces/eventhubs@2017-04-01' = {
  name: '${eventHubsNameSpace.name}/${eventHubName}'
  properties: {
    messageRetentionInDays: 1
    partitionCount: 1
  }
}

output eventHubsNameSpaceName string = eventHubsNameSpaceName
output eventHubSharedAccessKey string = eventHubsNameSpaceSharedAccessKey
output eventHubConnectionString string = 'Endpoint=sb://${eventHubsNameSpaceName}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${eventHubsNameSpaceSharedAccessKey}'
