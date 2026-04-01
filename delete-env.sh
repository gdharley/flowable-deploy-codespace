delete_cluster() {
    local cluster_name="$1"
    echo "Deleting kind cluster '$cluster_name'..."
    
    # Switch to the cluster context if it exists
    if kubectl config get-contexts "kind-$cluster_name" >/dev/null 2>&1; then
        kubectl config use-context "kind-$cluster_name"
        
        # Uninstall Helm releases
        echo "Uninstalling Helm releases in cluster '$cluster_name'..."
        helm uninstall flowable --namespace dev 2>/dev/null || true
        helm uninstall flowable --namespace test 2>/dev/null || true
        helm uninstall flowable --namespace stg 2>/dev/null || true
        
        # Delete namespaces to ensure pods are shut down
        kubectl delete namespace dev test stg ci actions-runner-system cert-manager ingress-nginx 2>/dev/null || true
    fi
    
    kind delete cluster --name "$cluster_name"
    
    # Remove kubeconfig context for the cluster
    kubectl config delete-context "kind-$cluster_name" 2>/dev/null || true
    kubectl config delete-cluster "kind-$cluster_name" 2>/dev/null || true
    kubectl config delete-user "kind-$cluster_name" 2>/dev/null || true
}

# Check for --all flag
if [[ "$1" == "--all" ]]; then
	# Array of configurations: (namespace release_name cluster_name)
	configs=(
		"qa"
		"prod"
	)
	for config in "${configs[@]}"; do
		set -- $config
		delete_cluster "$1"
	done
    
    # Delete the shared registry container
    echo "Deleting shared registry container..."
    docker stop kind-registry 2>/dev/null || true
    docker rm kind-registry 2>/dev/null || true
    
    # Clean up any dangling resources
    echo "Cleaning up dangling Docker resources..."
    docker system prune -f
else
    CLUSTER_NAME="${1:-kind}"
    delete_cluster "$CLUSTER_NAME"
fi