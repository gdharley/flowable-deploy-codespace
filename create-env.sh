
#!/bin/bash

DISABLE_ARC="${4:-false}"
SINGLE_NODE="${5:-false}"
# Reusable function for cluster setup
setup_cluster() {
	local cluster_name="$1"
	echo "Setting up kind cluster '$cluster_name'"
	"$CODESPACE_VSCODE_FOLDER/scripts/kind-cluster-setup.sh" "$cluster_name" false false
	bash -c "echo \"Opening new shell\""

}

# Reusable function for deployment
deploy_flowable() {
	local namespace="$1"
	local release_name="$2"
	echo "Deploying Flowable Platform in namespace '$namespace' with release name '$release_name'"
	"$CODESPACE_VSCODE_FOLDER/scripts/deploy-flowable-platform.sh" "$namespace" "$release_name"
}


# Default to --all when no arguments are provided
if [[ $# -eq 0 ]]; then
  echo "No arguments provided; defaulting to --all"
  set -- --all
fi

# Check for --all flag
if [[ "$1" == "--all" ]]; then
	# Array of configurations: (namespace release_name cluster_name)
	configs=(
		"dev flowable qa"
        "test flowable qa"
		"stg flowable prod"
	)
	for config in "${configs[@]}"; do
		set -- $config
		setup_cluster "$3"
		deploy_flowable "$1" "$2"
		# kubectl config set-context --current  --cluster="$3" --namespace="$1"
	done
else
	NAMESPACE="${1:-dev}"
	RELEASE_NAME="${2:-flowable}"
	CLUSTER_NAME="${3:-kind}"
	setup_cluster "$CLUSTER_NAME"
	deploy_flowable "$NAMESPACE" "$RELEASE_NAME"
	# kubectl config set-context --current  --cluster="$CLUSTER_NAME"-kind --namespace="$NAMESPACE"
fi

#/bin/bash -c "k9s -c --crumbless"
