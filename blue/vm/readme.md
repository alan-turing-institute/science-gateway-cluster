# Deployment of pbs/torque-enabled cluster

## Deployment instructions

```shell
RESOURCE_GROUP="Science-Gateway-Cluster"
az group create --name $RESOURCE_GROUP --location westeurope
az group deployment create --resource-group $RESOURCE_GROUP --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
```

Note, that the hosted deploy script is referenced within `azuredeploy.json`

```json
"settings": {
  "fileUris": [
    "https://raw.githubusercontent.com/alan-turing-institute/science-gateway-cluster/master/blue/vm/azuredeploy.sh"
  ]
}
```