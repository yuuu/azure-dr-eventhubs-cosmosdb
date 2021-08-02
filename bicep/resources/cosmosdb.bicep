param appName string
param environment string
param cosmosDBContainerName string

var cosmosDBAccountName = toLower('${appName}Account${environment}')
var dbName = '${appName}Database${environment}'
var cosmosDBAccountID = cosmosDBAccount.id

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-01-preview' = {
  name: cosmosDBAccountName
  location: resourceGroup().location
  properties: {
    databaseAccountOfferType: 'Standard'
    createMode: 'Default'
    enableAutomaticFailover: true
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxStalenessPrefix: 10
      maxIntervalInSeconds: 200
    }
    locations: [
      {
        locationName: resourceGroup().location
        failoverPriority: 0
        isZoneRedundant: true
      }
    ]
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 1440 // バックアップ間隔(分) 24時間
        backupRetentionIntervalInHours: 168 // 保持期間 7日間
      }
    }
  }
  tags: {
    env: environment
  }
}

resource cosmosDBAccountName_dbName 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-01-15' = {
  name: '${cosmosDBAccount.name}/${dbName}'
  properties: {
    resource: {
      id: dbName
    }
  }
  tags: {
    env: environment
  }
}

resource cosmosDBAccountName_dbName_sensor_values 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-03-01-preview' = {
  name: '${cosmosDBAccountName_dbName.name}/${cosmosDBContainerName}'
  location: resourceGroup().location
  properties: {
    resource: {
      id: 'temperatures'
      partitionKey: {
        paths: [
          '/user_id'
        ]
      }
      defaultTtl: 86400
    }
    options: {
      throughput: 1000
    }
  }
  tags: {
    env: environment
  }
}

output cosmosDBAccountName string = cosmosDBAccountName
output cosmosDBDBName string = dbName
output cosmosDBSharedAccessKey string = listKeys(cosmosDBAccountID, '2021-03-15').primaryMasterKey
output cosmosDBConnectionString string = 'AccountEndpoint=https://${cosmosDBAccountName}.documents.azure.com:443/;AccountKey=${listKeys(cosmosDBAccountID, '2021-03-15').primaryMasterKey};'
