#region Services in your cluster should only be able to make requests to other services if explicitly required.

# Testing based on docs: https://learn.microsoft.com/en-us/azure/aks/use-network-policies

# Create a server pod. This pod will serve on TCP port 80:
kubectl run server -n default --image=k8s.gcr.io/e2e-test-images/agnhost:2.33 --labels="app=server" --port=80 --command -- /agnhost serve-hostname --tcp --http=false --port "80"

# Create a client pod. The below command will run bash on the client pod:
kubectl run -it client -n default --image=k8s.gcr.io/e2e-test-images/agnhost:2.33 --command -- bash

# Now, in a separate window, run the following command to get the server IP:
kubectl get pod --output=wide -n default

# Test Connectivity without Network Policy
# /agnhost connect <server-ip>:80 --timeout=3s --protocol=tcp

# There will be no output if the connection is successful
/agnhost connect 10.2.0.91:80 --timeout=3s --protocol=tcp

# Test Connectivity with Network Policy
kubectl apply -f /workspaces/2023-openhack-containers/team-work/k8s-deployments/demo-network-policy.yaml

/agnhost connect 10.2.0.103:80 --timeout=3s --protocol=tcp

# Connectivity with traffic will be blocked since the server is labeled with app=server, but the client isn't labeled. Run the following command to label the client:
kubectl label pod client -n demo app=client

/agnhost connect 10.2.0.103:80 --timeout=3s --protocol=tcp

# Reference/starting point https://github.com/ahmetb/kubernetes-network-policy-recipes/blob/master/02-limit-traffic-to-an-application.md
kubectl apply -f /workspaces/2023-openhack-containers/team-work/k8s-deployments/api-network-policy-limit-traffic.yaml
kubectl apply -f /workspaces/2023-openhack-containers/team-work/k8s-deployments/api-network-policy-default-deny.yaml

# We labeled manually since updating the deployments with new labels did not work
kubectl label pod poi-58949b98dd-257mb -n api role=api
kubectl label pod userjava-54fdbfcf98-4rfkn -n api role=api

# We then ran kubectl exec into userjava-54fdbfcf98-4rfkn and verified that curl http://poi-service/api/poi stopped working after applying the policies

#endregion