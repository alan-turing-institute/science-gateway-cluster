# Azure VM running BEMPP docker with Flask science gateway compute web service

These files allow the creation of an Azure VM running a BEMPP docker image that has been augmented with a Flask web service exposing the science gateway commands.

## Bash command line deployment instructions

Copy the template JSON parameters to `azuredeploy.parameters.json` (which is ignored in `.gitignore`):

```shell
cp azuredeploy.parameters.template.json azuredeploy.parameters.json
```

Manually set a password and DNS name in `azuredeploy.parameters.json` (i.e. change the two strings `parameters.adminPassword.value` and `parameters.dnsLabelPrefix.value`).

Make sure you are logged into the Azure `az` command line client and the target subscription is set as default by running the commands below if necessary.

```shell
az login
az account set -s "<subscription-name>"
```
Ensure that a resource group named `Science-Gateway-Cluster-Bempp` exists in the `westeurope` region.

Run the following from a bash shell:

```shell
RESOURCE_GROUP="Science-Gateway-Cluster-Bempp"
az group create --name $RESOURCE_GROUP --location westeurope
az group deployment create --resource-group $RESOURCE_GROUP --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
```

Note, progress of deploy can be monitored using

```shell
ssh vm-admin@<parameters.dnsLabelPrefix.value>.westeurope.cloudapp.azure.com
tail -f /tmp/azuredeploy.log.*
```

where `<parameters.dnsLabelPrefix.value>` corresponds to the name provided in `azuredeploy.parameters.json`.
