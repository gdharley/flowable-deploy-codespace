#!/bin/bash
set -euo pipefail

# Move to repository root no matter where this script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

# Ensure origin points to the current GitHub repository when available.
if [ -n "${GITHUB_REPOSITORY:-}" ]; then
  ORIGIN_URL="https://github.com/${GITHUB_REPOSITORY}.git"
  if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "${ORIGIN_URL}"
  else
    git remote add origin "${ORIGIN_URL}"
  fi
fi

# Keep local refs current; do not fail setup if network is temporarily unavailable.
git fetch --all --tags || true

# Check out dev branch when present.
if git rev-parse --verify dev >/dev/null 2>&1; then
  git checkout dev
elif git ls-remote --exit-code --heads origin dev >/dev/null 2>&1; then
  git checkout -b dev origin/dev
fi

# Keep submodules aligned with the checked-out branch.
git submodule sync --recursive
git submodule update --init --recursive

# Ensure repo scripts are executable.
chmod +x scripts/* || true

# Install Homebrew when missing.
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found; installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "/home/ubuntu/.linuxbrew" ]; then
    eval "$(/home/ubuntu/.linuxbrew/bin/brew shellenv)"
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "brew command unavailable after attempted install."
  exit 1
fi

# Install required local tools.
echo "Installing kind and k9s via Homebrew..."
brew install kind k9s

# Install cert-manager for cluster webhooks/certificates when kubectl can reach a cluster.
if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
  echo "Installing cert-manager for cluster webhooks and certificates..."
  helm repo add jetstack https://charts.jetstack.io >/dev/null 2>&1 || true
  helm repo update

  helm upgrade --install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --set installCRDs=true \
    --wait \
    --timeout=120s

  echo "cert-manager installed successfully."
else
  echo "Skipping cert-manager install (kubectl is unavailable or cluster is not reachable)."
fi
