#!/bin/bash
set -euo pipefail

if ! command -v brew > /dev/null; then
  echo "Homebrew not found; installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -d "/home/linuxbrew/.linuxbrew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -d "/home/ubuntu/.linuxbrew" ]; then
    eval "$(/home/ubuntu/.linuxbrew/bin/brew shellenv)"
  fi
fi

# Ensure brew command is available in current shell
if ! command -v brew > /dev/null; then
  echo "brew command still unavailable after install. Exiting."
  exit 1
fi

echo "Installing kind and k9s via Homebrew..."
brew install kind k9s

echo "Tool installation completed."
