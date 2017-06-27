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

Copy the template JSON parameters to `azuredeploy.parameters.json` (which is ignored in `.gitignore`):

```shell
cp azuredeploy.parameters.template.json azuredeploy.parameters.json
```

Manually set a password and DNS name in `azuredeploy.parameters.json` (i.e. change the two strings `parameters.adminPassword.value` and `parameters.dnsLabelPrefix.value`).

Run the following from a bash shell:

```shell
RESOURCE_GROUP="Science-Gateway-Cluster"
az group create --name $RESOURCE_GROUP --location westeurope
az group deployment create --resource-group $RESOURCE_GROUP --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
```

Note, progress of deploy can be monitored using

```shell
ssh vm-admin@<parameters.dnsLabelPrefix.value>.westeurope.cloudapp.azure.com
tail -f /tmp/azuredeploy.log.*
```

where `<parameters.dnsLabelPrefix.value>` corresponds to the name provided in `azuredeploy.parameters.json`.