$IDENTITY_RESOURCE_GROUP = "teamResources"
$IDENTITY_NAME = "pod-identity"

az identity create -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME}
$IDENTITY_CLIENT_ID = "$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query clientId -otsv)"
$IDENTITY_RESOURCE_ID = "$(az identity show -g ${IDENTITY_RESOURCE_GROUP} -n ${IDENTITY_NAME} --query id -otsv)"

/subscriptions/401ef870-009b-4f75-9938-f7b20a5a3636/resourcegroups/teamResources/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pod-identity
4048d67d-0d4b-4a2d-9ba7-efd63d52573e

apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
name: ${IDENTITY_NAME}
spec:
type: 0
resourceID: /subscriptions/401ef870-009b-4f75-9938-f7b20a5a3636/resourcegroups/teamResources/providers/Microsoft.ManagedIdentity/userAssignedIdentities/pod-identity
clientID: ${IDENTITY_CLIENT_ID}

apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
name: ${IDENTITY_NAME}-binding
spec:
azureIdentity: ${IDENTITY_NAME}
selector: ${IDENTITY_NAME}

apiVersion: v1
kind: Pod
metadata:
name: demo
labels:
aadpodidbinding: $IDENTITY_NAME
spec:
containers:
- name: demo
image: mcr.microsoft.com/oss/azure/aad-pod-identity/demo:v1.8.8
args:
- --subscription-id=${SUBSCRIPTION_ID}
- --resource-group=${IDENTITY_RESOURCE_GROUP}
- --identity-client-id=${IDENTITY_CLIENT_ID}
nodeSelector:
kubernetes.io/os: linux