# Welcome to azure-dr-eventhubs-cosmosdb 👋
![Version](https://img.shields.io/badge/version-0.0.1-blue.svg?cacheSeconds=2592000)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Twitter: Y\_uuu](https://img.shields.io/twitter/follow/Y\_uuu.svg?style=social)](https://twitter.com/Y\_uuu)

> A sample of region redundancy in the infrastructure that flows data from Azure Event Hubs to CosmosDB.

### 🏠 [Homepage](https://tech.fusic.co.jp/)

## Usage

```sh
LOCATION={ YOUR LOCATION }
RESOURCE_GROUP_NAME={ YOUR RESOURCE GROUP NAME }

az login
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
az configure --defaults group=$RESOURCE_GROUP_NAME

az deployment group create --template-file bicep/main.bicep --parameters main.parameters.json
```

## Author

👤 **yuuu**

* Twitter: [@Y\_uuu](https://twitter.com/Y\_uuu)
* Github: [@yuuu](https://github.com/yuuu)

## Show your support

Give a ⭐️ if this project helped you!

## 📝 License

Copyright © 2021 [yuuu](https://github.com/yuuu).

This project is [MIT](https://opensource.org/licenses/MIT) licensed.

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
