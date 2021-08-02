param appName string
param environment string

var deploymentEventHubsName = '${appName}CreateEventHubsName${environment}'
var deploymentCosmosDBName = '${appName}CreateCosmosDBName${environment}'
var deploymentStreamAnalyticsName =  '${appName}CreateStreamAnalyticsName${environment}'
var targetName = 'temperatures'

module deploymentEventHubs 'resources/eventhubs.bicep' = {
  name: deploymentEventHubsName
  params: {
    appName: appName
    environment: environment
    eventHubName: targetName
  }
}

module deploymentCosmosDB 'resources/cosmosdb.bicep' = {
  name: deploymentCosmosDBName
  params: {
    appName: appName
    environment: environment
    cosmosDBContainerName: targetName
  }
}

module deploymentStreamAnalytics 'resources/streamanalytics.bicep' = {
  name: deploymentStreamAnalyticsName
  params: {
    appName: appName
    environment: environment
    eventHubNameSpace: reference(deploymentEventHubsName).outputs.eventHubsNameSpaceName.value
    eventHubSharedAccessKey: reference(deploymentEventHubsName).outputs.eventHubSharedAccessKey.value
    eventHubName: targetName
    cosmosDBAccountName: reference(deploymentCosmosDBName).outputs.cosmosDBAccountName.value
    cosmosDBAccountKey: reference(deploymentCosmosDBName).outputs.cosmosDBSharedAccessKey.value
    cosmosDBDatabaseName: reference(deploymentCosmosDBName).outputs.cosmosDBDBName.value
    cosmosDBContainerName: targetName
  }
}
