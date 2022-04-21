$ACR_NAME = "registryxcw9261"
# Add the ACR to the K8s cluster

$acrResourceGroup = "teamResources"
$acrName = "registryxcw9261"

$acrID = $(az acr show --name "$acrName" --resource-group "$acrResourceGroup" --query "id" -output tsv)

az aks update --name "k8cluster" --resource-group "teamResources" --attach-acr "$acrID"

# Add the secrets / configMap to AKS Kubectl

$aksResourceGroup = "teamResources"
$aksCluster = "k8cluster"

az aks get-credentials --resource-group "$aksResourceGroup" --name "$aksCluster"

$username = "sqladminxCw9261"
$password = "letmein123]"

kubectl create secret generic sql-username --from-literal=username="sqladminxCw9261"
kubectl create secret generic sql-password --from-literal=password="letmein123]"

$sqlDatabase = "mydrivingDB"
$sqlServer = "sqlserverxcw9261.database.windows.net"

kubectl create configmap sqlConnection --from-literal=sqlServer="$sqlServer" --from-literal=sqlDatabase="$sqlDatabase"

<#
envFrom:
	- secretRef:
		name: sql

envFrom:
	secretKeyRef:
		name: sqlcredential
		key: password


envFrom:
	- secretRef:
		name: sql
	- secretRef:
		name: paypal-secret
	- secretRef:
		name: postgres-secret
	- secretRef:
		name: redis-secret


apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
#>