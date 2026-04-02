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

8. **Deregister GitHub Action Runners**:
   ```
   ./scripts/deregister-github-action-runners.sh <cluster-name>
   ```
   De-registers matching repository self-hosted runners with labels `self-hosted`, `arc`, and `<cluster-name>`.

9. **Port Forward HTTP**:
   ```
   ./scripts/port-forward-http.sh <namespace> [release-name] [--context <kube-context>] [--local-port <port>] [--ingress-namespace <namespace>]
   ```
   Port forwards `svc/ingress-nginx-controller` to a local port (default `8090`) for browser access. Examples:
   ```
   ./scripts/port-forward-http.sh dev --context kind-qa --local-port 8090
   ./scripts/port-forward-http.sh test --context kind-qa --local-port 8090
   ./scripts/port-forward-http.sh stg --context kind-prod --local-port 8091
   ```
   Paths to open:
   - `dev`: `/work`, `/control`, `/design`
   - `test`: `/test/work`, `/test/control`, `/test/design`
   - `stg`: `/work`, `/control`

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
  ./delete-env.sh
  ```
  Deletes Kind clusters and cleans up associated resources (registry, kubeconfig). Before cluster teardown, it also de-registers matching GitHub self-hosted runners (labels: `self-hosted`, `arc`, and the target cluster name) when `ARC_TOKEN` (or `GITHUB_TOKEN`) is available. With no args, defaults to `--all`, removing both "qa" and "prod" clusters completely for immediate recreation.

## Notes

- Scripts will check for required environment variables and exit with an error if missing (fail-fast behavior).
- `deploy-flowable-platform.sh` requires `FLOWABLE_REPO_USER`, `FLOWABLE_REPO_PASSWORD`, and `FLOWABLE_LICENSE_KEY` set before running.
- `manage-ns-and-secrets.sh create` also requires `FLOWABLE_REPO_USER` and `FLOWABLE_REPO_PASSWORD` and will fail if missing.
- No interactive prompting; all inputs must be provided via environment variables or arguments.
