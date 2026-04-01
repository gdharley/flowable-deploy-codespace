#!/bin/bash
set -o errexit

# Unified script for managing namespace secrets
# Usage: ./manage-ns-secrets.sh <action> <namespace> [release-name] [license-file-path]

ACTION="$1"
DEPLOYMENT_NAMESPACE="$2"
RELEASE_NAME="${3:-flowable}"
LICENSE_FILE_PATH="${4:-$HOME/.flowable/flowable.license}"

PROJECT_DIR="${CODESPACE_VSCODE_FOLDER:-$GITHUB_WORKSPACE}"
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
SCRIPTS_DIR="${SCRIPTS_DIR:-$PROJECT_DIR/scripts}"

# List of secrets
SECRETS=(
    "${RELEASE_NAME}-flowable-regcred"
    "${RELEASE_NAME}-flowable-license"
)

case "$ACTION" in
    create)
        echo "Creating secrets for namespace: $DEPLOYMENT_NAMESPACE"

        # Check for required argument (namespace)
        if [ -z "$DEPLOYMENT_NAMESPACE" ]; then
            echo "must specify namespace for secret creation"
            exit 1
        fi

        # Check if namespace exists, if not create it
        if kubectl get namespace "$DEPLOYMENT_NAMESPACE" >/dev/null 2>&1; then
            echo "Namespace $DEPLOYMENT_NAMESPACE exists. Will not attempt to create it."
        else
            echo "Namespace $DEPLOYMENT_NAMESPACE does not exist. Creating it now."
            source "$SCRIPTS_DIR/create-ns.sh" "$DEPLOYMENT_NAMESPACE"
        fi

        # Check for FLOWABLE_LICENSE_KEY
        if [ -z "$FLOWABLE_LICENSE_KEY" ]; then
            echo "FLOWABLE_LICENSE_KEY environment variable is not set. Your deployment is likely to fail."
        else
            echo "FLOWABLE_LICENSE_KEY is set. Writing its contents to $LICENSE_FILE_PATH"
            mkdir -p "$HOME/.flowable"
            echo "$FLOWABLE_LICENSE_KEY" > "$LICENSE_FILE_PATH"
            chmod 600 "$LICENSE_FILE_PATH"
        fi

        if [ -z "$FLOWABLE_REPO_USER" ]; then
            echo "FLOWABLE_REPO_USER env variable is not set. Secret creation will fail."
            exit 1
        fi

        if [ -z "$FLOWABLE_REPO_PASSWORD" ]; then
            echo "FLOWABLE_REPO_PASSWORD env variable is not set. Secret creation will fail."
            exit 1
        fi

        # Delete existing secrets first
        echo "Attempting to delete existing secrets to avoid 'AlreadyExists' errors"
        "$0" delete "$DEPLOYMENT_NAMESPACE" "$RELEASE_NAME"

        # Create secrets
        kubectl create secret docker-registry "$RELEASE_NAME-flowable-regcred" \
            --docker-server=repo.flowable.com \
            --docker-username="$FLOWABLE_REPO_USER" \
            --docker-password="$FLOWABLE_REPO_PASSWORD" \
            --namespace "$DEPLOYMENT_NAMESPACE"

        kubectl create secret generic "$RELEASE_NAME-flowable-license" \
            --from-file=flowable.license="$LICENSE_FILE_PATH" \
            --namespace "$DEPLOYMENT_NAMESPACE"

        echo "Secrets created successfully."
        ;;

    delete)
        if [ -z "$DEPLOYMENT_NAMESPACE" ]; then
            echo "must specify namespace for secret deletion"
            exit 1
        fi

        DELETE_ALL="${4:-}"
        if [[ "$DELETE_ALL" == "--all" ]]; then
            echo "Deleting ALL secrets in namespace '$DEPLOYMENT_NAMESPACE'..."
            kubectl delete secrets --all -n "$DEPLOYMENT_NAMESPACE" 2>/dev/null || true
        else
            echo "Deleting Flowable secrets in namespace '$DEPLOYMENT_NAMESPACE'..."
            for secret in "${SECRETS[@]}"; do
                if kubectl get secret "$secret" -n "$DEPLOYMENT_NAMESPACE" &>/dev/null; then
                    kubectl delete secret "$secret" -n "$DEPLOYMENT_NAMESPACE"
                    echo "Deleted secret: $secret"
                else
                    echo "Secret not found: $secret"
                fi
            done
        fi
        ;;

    recreate)
        "$0" delete "$DEPLOYMENT_NAMESPACE" "$RELEASE_NAME"
        "$0" create "$DEPLOYMENT_NAMESPACE" "$RELEASE_NAME" "$LICENSE_FILE_PATH"
        ;;

    *)
        echo "Usage: $0 <action> <namespace> [release-name] [license-file-path]"
        echo "Actions: create, delete, recreate"
        echo "For delete, optional --all as 4th arg to delete all secrets"
        exit 1
        ;;
esac