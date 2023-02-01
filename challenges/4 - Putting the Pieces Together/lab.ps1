# https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver

az login --use-device

az aks get-credentials --resource-group teamResources --name akschallenge3

az aks install-cli

kubectl get nodes

az aks enable-addons --addons azure-keyvault-secrets-provider --name akschallenge3 --resource-group teamResources

kubectl get pods -n kube-system -l 'app in (secrets-store-csi-driver,secrets-store-provider-azure)'

az keyvault create -n akskvteam11 -g teamResources -l northeurope

az keyvault secret set --vault-name akskvteam11 -n testsecret --value SuperSecret

kubectl get pods



# Ingress

kubectl create namespace ingress-basic

$NAMESPACE="ingress-basic"

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx --create-namespace --namespace $NAMESPACE --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz


