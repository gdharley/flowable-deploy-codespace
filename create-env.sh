
#!/bin/bash

DISABLE_ARC="${4:-false}"
SINGLE_NODE="${5:-false}"
# Reusable function for cluster setup
setup_cluster() {
	local cluster_name="$1"
	echo "Setting up kind cluster '$cluster_name'"
	export EXTRA_MOUNT_HOST_PATH=docker/keycloak
	"$CODESPACE_VSCODE_FOLDER/scripts/kind-cluster-setup.sh" "$cluster_name" false false
	bash -c "echo \"Opening new shell\""

	export KEYCLOAK_BASE_URL="${CODESPACE_NAME}-80.app.github.dev"
	# export LOGIN_URL="${KEYCLOAK_BASE_URL}/login"
	## set redirect and weborigin uris for keycloak container
	jq --arg uri "https://${KEYCLOAK_BASE_URL}/*" '.clients[] |= if .clientId == "global-sales-demo" then .redirectUris[0] = $uri else . end' docker/keycloak/global-sales-demo-realm.json > /tmp/global-sales-demo-realm.json
	mv /tmp/global-sales-demo-realm.json docker/keycloak/realm.json	
	
	jq --arg uri "https://${KEYCLOAK_BASE_URL}/*" '.clients[] |= if .clientId == "global-sales-demo" then .webOrigins[0] = $uri else . end' docker/keycloak/realm.json > /tmp/global-sales-demo-realm.json
	mv /tmp/global-sales-demo-realm.json docker/keycloak/realm.json

	export KEYCLOAK_CLIENT_SECRET=some-super-secret-key
	jq --arg secret "${KEYCLOAK_CLIENT_SECRET}" '.clients[] |= if .clientId == "global-sales-demo" then .secret = $secret else . end' docker/keycloak/realm.json > /tmp/global-sales-demo-realm.json
	mv /tmp/global-sales-demo-realm.json docker/keycloak/realm.json

	jq --arg uri "https://${KEYCLOAK_BASE_URL}" '.clients[] |= if .clientId == "global-sales-demo" then .adminUrl = $uri else . end' docker/keycloak/realm.json > /tmp/global-sales-demo-realm.json
	mv /tmp/global-sales-demo-realm.json docker/keycloak/realm.json

	brew install yq
	bash -c "echo \"Opening new shell\""
	yq -i '.keycloak.host = strenv(KEYCLOAK_BASE_URL)' helm/stg/values.yaml

	## Build keycloak image
	# docker build -t keycloak-global-sales:12.0.8 docker/keycloak
	# docker tag keycloak-global-sales:12.0.8 localhost:5001/keycloak-global-sales:20.0.0
	# docker push localhost:5001/keycloak-global-sales:20.0.0
}

# Reusable function for deployment
deploy_flowable() {
	local namespace="$1"
	local release_name="$2"
	echo "Deploying Flowable Platform in namespace '$namespace' with release name '$release_name'"
	"$CODESPACE_VSCODE_FOLDER/scripts/deploy-flowable-platform.sh" "$namespace" "$release_name"
}


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

/bin/bash -c "k9s -c --crumbless"
