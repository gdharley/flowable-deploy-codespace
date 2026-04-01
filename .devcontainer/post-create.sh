#!/bin/bash
set -e

echo "Installing cert-manager for cluster webhooks and certificates..."

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --wait \
  --timeout=120s

echo "✓ cert-manager installed successfully."
