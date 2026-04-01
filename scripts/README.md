# Flowable Kind Scripts

Scripts for setting up and deploying Flowable on a Kind cluster.

## Prerequisites

Ensure the following environment variables are set before running the scripts:

- `FLOWABLE_REPO_USER`: Email associated with Flowable Artifactory
- `FLOWABLE_REPO_PASSWORD`: Password associated with Flowable Artifactory
- `FLOWABLE_LICENSE_KEY`: Raw text value of Flowable license
- `ARC_TOKEN`: GitHub Personal Access Token (for GitHub Actions Runner setup)

These can be set as Codespace secrets or exported in your shell.

## Additional dependencies

- **Cert Manager**: Automatically installed during Codespace post-create setup. If running `kind-cluster-setup.sh` standalone, it will check for cert-manager and install it if missing.

## Scripts

1. **Create Kind Cluster**:
   ```
   ./scripts/kind-cluster-setup.sh
   ```
   Creates a 4-node Kind cluster. Installs Kind and K9s if not present.

2. **Deploy Flowable Platform**:
   ```
   ./scripts/deploy-flowable-platform.sh <release-name> [namespace]
   ```
   Deploys Flowable using Helm. Requires the namespace to exist or will create it.

3. **Manage Namespace and Secrets**:
   ```
   ./scripts/manage-ns-and-secrets.sh <action> <namespace> [release-name] [license-file-path]
   ```
   Unified script for secret management. Actions: `create`, `delete`, `recreate`.

4. **Create Namespace Secrets** (legacy):
   ```
   ./scripts/create-ns-secrets.sh <namespace> [release-name] [license-file-path]
   ```
   Wrapper for `manage-ns-and-secrets.sh create`.

6. **Add GitHub Actions Runner**:
   ```
   ./scripts/add-github-action-runner.sh [cluster-name]
   ```
   Sets up Actions Runner Controller (ARC) and deploys a GitHub Actions runner.

7. **Delete Namespace Secrets** (legacy):
   ```
   ./scripts/delete-ns-secrets.sh <namespace> [release-name] [--all]
   ```
   Wrapper for `manage-ns-and-secrets.sh delete`. Use `--all` to delete all secrets.

7. **Port Forward HTTP**:
   ```
   ./scripts/port-forward-http.sh <namespace> [release-name]
   ```
   Port forwards the ingress-nginx controller in the specified namespace to local port 8090 for accessing the Flowable UI.

## Environment Scripts

- **Create Environment**:
  ```
  ./create-env.sh --all
  ./create-env.sh <namespace> <release_name> <cluster_name>
  ./create-env.sh
  ```
  - `--all`: (default when no args supplied) deploys the 3 config sets (qa/dev, qa/test, prod/stg)
  - `<namespace> <release_name> <cluster_name>`: single-target deploy path
  - no args: defaults to `--all` behavior

  Creates Kind clusters and deploys Flowable. 

- **Delete Environment**:
  ```
  ./delete-env.sh --all
  ```
  Deletes Kind clusters and cleans up associated resources (registry, kubeconfig). For `--all`, removes "qa" and "prod" clusters completely, allowing immediate recreation.

## Notes

- Scripts will check for required environment variables and exit with an error if missing (fail-fast behavior).
- `deploy-flowable-platform.sh` requires `FLOWABLE_REPO_USER`, `FLOWABLE_REPO_PASSWORD`, and `FLOWABLE_LICENSE_KEY` set before running.
- `manage-ns-and-secrets.sh create` also requires `FLOWABLE_REPO_USER` and `FLOWABLE_REPO_PASSWORD` and will fail if missing.
- No interactive prompting; all inputs must be provided via environment variables or arguments.
