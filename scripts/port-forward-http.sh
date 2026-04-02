#!/bin/bash

set -e

usage() {
    cat <<EOF
Usage: $0 <namespace> [release_name] [--context <kube-context>] [--local-port <port>] [--ingress-namespace <namespace>]

Examples:
  $0 dev
  $0 test --context kind-qa --local-port 8090
  $0 stg --context kind-prod --local-port 8091
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

APP_NAMESPACE="$1"
shift

# Backward-compatible positional release_name (currently unused by this script)
if [[ $# -gt 0 && "$1" != --* ]]; then
    RELEASE_NAME="$1"
    shift
else
    RELEASE_NAME="flowable"
fi

KUBE_CONTEXT=""
LOCAL_PORT=8090
INGRESS_NAMESPACE="ingress-nginx"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --context)
            KUBE_CONTEXT="${2:-}"
            shift 2
            ;;
        --local-port)
            LOCAL_PORT="${2:-}"
            shift 2
            ;;
        --ingress-namespace)
            INGRESS_NAMESPACE="${2:-}"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ -z "$KUBE_CONTEXT" ]]; then
    KUBE_CONTEXT="$(kubectl config current-context)"
fi

if [[ -z "$KUBE_CONTEXT" ]]; then
    echo "No Kubernetes context is set."
    exit 1
fi

KUBECTL=(kubectl --context "$KUBE_CONTEXT")

if ! "${KUBECTL[@]}" get namespace "$INGRESS_NAMESPACE" >/dev/null 2>&1; then
    echo "Ingress namespace '$INGRESS_NAMESPACE' was not found in context '$KUBE_CONTEXT'."
    exit 1
fi

if ! "${KUBECTL[@]}" get svc ingress-nginx-controller -n "$INGRESS_NAMESPACE" >/dev/null 2>&1; then
    echo "Service 'ingress-nginx-controller' not found in namespace '$INGRESS_NAMESPACE' (context '$KUBE_CONTEXT')."
    exit 1
fi

echo "Context: $KUBE_CONTEXT"
echo "App namespace: $APP_NAMESPACE"
echo "Ingress namespace: $INGRESS_NAMESPACE"
echo "Release name: $RELEASE_NAME"
echo "Port-forward: localhost:$LOCAL_PORT -> svc/ingress-nginx-controller:80"
echo
echo "After this starts, open one of:"
echo "  /work   /control   /design"
echo "If namespace is test, open:"
echo "  /test/work   /test/control   /test/design"
echo

"${KUBECTL[@]}" port-forward -n "$INGRESS_NAMESPACE" svc/ingress-nginx-controller "$LOCAL_PORT:80"

# Find a pod containing "engage"
# ENGAGE_POD=$(kubectl get pods -n "$NAMESPACE" --no-headers -o custom-columns=":metadata.name" | grep engage | head -n1)
# if [ -z "$ENGAGE_POD" ]; then
#     echo "No pod containing 'engage' found in namespace $NAMESPACE"
# else
#     echo "Port-forwarding $ENGAGE_POD 8080 -> 8080 (local)"
#     kubectl port-forward -n "$NAMESPACE" pod/"$ENGAGE_POD" 8080:8080 &
# fi

# # Find a pod containing "design"
# DESIGN_POD=$(kubectl get pods -n "$NAMESPACE" --no-headers -o custom-columns=":metadata.name" | grep design | head -n1)
# if [ -n "$DESIGN_POD" ]; then
#     echo "Port-forwarding $DESIGN_POD 8080 -> 8081 (local)"
#     kubectl port-forward -n "$NAMESPACE" pod/"$DESIGN_POD" 8081:8080 &
# else
#     echo "No pod containing 'design' found in namespace $NAMESPACE"
# fi

# # Find a pod containing "control"
# CONTROL_POD=$(kubectl get pods -n "$NAMESPACE" --no-headers -o custom-columns=":metadata.name" | grep control | head -n1)
# if [ -z "$CONTROL_POD" ]; then
#     echo "No pod containing 'control' found in namespace $NAMESPACE"
# else
#     echo "Port-forwarding $CONTROL_POD 8080 -> 8082 (local)"
#     kubectl port-forward -n "$NAMESPACE" pod/"$CONTROL_POD" 8082:8080 &
# fi
