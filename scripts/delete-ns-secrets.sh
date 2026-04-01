#!/usr/bin/env bash
set -euo pipefail

# Wrapper for backward compatibility
# Calls manage-ns-secrets.sh delete

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <DEPLOYMENT_NAMESPACE> [RELEASE_NAME] [--all]"
    exit 1
fi

DEPLOYMENT_NAMESPACE="$1"
RELEASE_NAME="${2:-flowable}"
DELETE_ALL="${3:-}"

PROJECT_DIR="${CODESPACE_VSCODE_FOLDER:-$GITHUB_WORKSPACE}"
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
SCRIPTS_DIR="${SCRIPTS_DIR:-$PROJECT_DIR/scripts}"

# Call the unified script
if [[ "$DELETE_ALL" == "--all" ]]; then
    "$SCRIPTS_DIR/manage-ns-and-secrets.sh" delete "$DEPLOYMENT_NAMESPACE" "$RELEASE_NAME" --all
else
    "$SCRIPTS_DIR/manage-ns-and-secrets.sh" delete "$DEPLOYMENT_NAMESPACE" "$RELEASE_NAME"
fi
