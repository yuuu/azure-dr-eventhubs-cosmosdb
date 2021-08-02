param appName string
param environment string
param eventHubNameSpace string
param eventHubSharedAccessKey string
param eventHubName string
param cosmosDBAccountName string
param cosmosDBAccountKey string
param cosmosDBDatabaseName string
param cosmosDBContainerName string

resource streamAnalytics 'Microsoft.StreamAnalytics/streamingjobs@2017-04-01-preview' = {
  name: '${appName}-${environment}'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'Standard'
    }
    jobType: 'Cloud'
    outputStartMode: 'JobStartTime'
    eventsOutOfOrderPolicy: 'Adjust'
    outputErrorPolicy: 'Stop'
    eventsOutOfOrderMaxDelayInSeconds: 0
    eventsLateArrivalMaxDelayInSeconds: 5
    dataLocale: 'en-US'
    inputs: [
      {
        name: 'YourInputAlias'
        properties: {
          datasource: {
            type: 'Microsoft.ServiceBus/EventHub'
            properties: {
              serviceBusNamespace: eventHubNameSpace
              sharedAccessPolicyName: 'RootManageSharedAccessKey'
              sharedAccessPolicyKey: eventHubSharedAccessKey
              eventHubName: eventHubName
            }
          }
          type: 'Stream'
          serialization: {
            type: 'Json'
            properties: {
              encoding: 'UTF8'
            }
          }
        }
      }
    ]
    transformation: {
      name: 'Transformation'
      properties: {
        query: 'SELECT * INTO [YourOutputAlias] FROM [YourInputAlias]'
        streamingUnits: 1
      }
    }
    outputs: [
      {
        name: 'YourOutputAlias'
        properties: {
          datasource: {
            type: 'Microsoft.Storage/DocumentDB'
            properties: {
              accountId: cosmosDBAccountName
              accountKey: cosmosDBAccountKey
              database: cosmosDBDatabaseName
              collectionNamePattern: cosmosDBContainerName
            }
          }
        }
      }
    ]
  }
}
