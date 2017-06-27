# Azure pbs/torque-enabled cluster

These files allow the creation of a mock pbs/torque-enabled cluster running on a single Ubuntu VM. The user password and DNS prefix are currently set within `azuredeploy.parameters.json`. Note, that the hosted deploy script is referenced within `azuredeploy.json` itself, hence any changes to `azuredeploy.sh` need to be pushed to this repository to be active.

```json
"settings": {
  "fileUris": [
    "https://raw.githubusercontent.com/alan-turing-institute/science-gateway-cluster/master/blue/vm/azuredeploy.sh"
  ]
}
```

## Bash command line deployment instructions

Run the following from a bash shell:

```shell
RESOURCE_GROUP="Science-Gateway-Cluster"
az group create --name $RESOURCE_GROUP --location westeurope
az group deployment create --resource-group $RESOURCE_GROUP --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
```

Note, progress of deploy can be monitored using

```shell
ssh vm-admin@science-gateway-cluster.westeurope.cloudapp.azure.com
tail -f /tmp/azuredeploy.log.*
```

