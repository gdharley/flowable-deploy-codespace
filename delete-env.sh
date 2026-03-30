delete_cluster() {
    kind delete cluster --name "$1"
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
else
    CLUSTER_NAME="${1:-kind}"
    delete_cluster "$CLUSTER_NAME"
fi