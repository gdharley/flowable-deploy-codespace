#!/bin/bash

set -o errexit

# Wrapper for backward compatibility
# Calls manage-ns-secrets.sh create

RELEASE_NAME="${2:-flowable}"
LICENSE_FILE_PATH="${3:-$HOME/.flowable/flowable.license}"

PROJECT_DIR="${CODESPACE_VSCODE_FOLDER:-$GITHUB_WORKSPACE}"
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
SCRIPTS_DIR="${SCRIPTS_DIR:-$PROJECT_DIR/scripts}"

echo
echo "Project directory is: $PROJECT_DIR"
echo "Scripts directory is: $SCRIPTS_DIR"

# Call the unified script
"$SCRIPTS_DIR/manage-ns-secrets.sh" create "$1" "$RELEASE_NAME" "$LICENSE_FILE_PATH"
