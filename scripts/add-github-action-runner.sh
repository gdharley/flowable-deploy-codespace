#!/bin/bash
set -o errexit

CLUSTER_NAME="${1:-kind}"
PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
SCRIPTS_DIR="${SCRIPTS_DIR:-$PROJECT_DIR/scripts}"

# Fail fast on missing token
if [ -z "$ARC_TOKEN" ]; then
  echo "Error: ARC_TOKEN is required for GitHub Actions Runner setup."
  echo "Please export ARC_TOKEN in your environment before running this script."
  exit 1
fi

# Ensure required namespaces exist
kubectl get namespace actions-runner-system >/dev/null 2>&1 || kubectl create namespace actions-runner-system
kubectl get namespace ci >/dev/null 2>&1 || kubectl create namespace ci

# Ensure Helm repo is available
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller 2>/dev/null || true
helm repo update

# Install/upgrade the ARC controller and configure auth secret
helm upgrade --install actions-runner-controller \
  actions-runner-controller/actions-runner-controller \
  --namespace actions-runner-system \
  --set authSecret.create=true \
  --set authSecret.github_token="$ARC_TOKEN"

kubectl -n actions-runner-system rollout status deploy/actions-runner-controller --timeout=180s

# Ensure runner namespace + RBAC + runner deployment
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: apps
---
apiVersion: v1
kind: Namespace
metadata:
  name: ci
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gh-runner
  namespace: ci
automountServiceAccountToken: true
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: gh-runner-read-cluster
rules:
  - apiGroups: ["", "apps", "ci"]
    resources: ["pods", "configmaps", "secrets", "services", "deployments", "replicasets", "namespaces", "statefulsets", "daemonsets", "jobs", "cronjobs", "ingresses", "networkpolicies", "pods", "pods/log", "pods/exec", "serviceaccounts", "persistentvolumeclaims"]
    verbs: ["get","list","watch","create","update","patch","delete"]
  - apiGroups: ["networking.k8s.io"]
    resources: ["networkpolicies", "ingresses", "ingressclasses"]
    verbs: ["get","list","watch","create","update","patch","delete"]
  - apiGroups: ["policy"]
    resources: ["poddisruptionbudgets"]
    verbs: ["get","list","watch","create","update","patch","delete"]
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get","list","watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: gh-runner-read-cluster
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: gh-runner-read-cluster
subjects:
  - kind: ServiceAccount
    name: gh-runner
    namespace: ci
---
apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: repo-runner
  namespace: ci
spec:
  replicas: 1
  template:
    spec:
      repository: "${GITHUB_REPOSITORY}"
      labels: [self-hosted, kind, arc, "${CLUSTER_NAME}"]
      serviceAccountName: gh-runner
EOF

echo "GitHub Actions runner deployment complete in cluster '$CLUSTER_NAME'."
