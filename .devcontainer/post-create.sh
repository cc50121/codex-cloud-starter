#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

echo "Installing the latest Codex CLI..."
npm install --global @openai/codex@latest

echo "Preparing project dependencies..."
bash scripts/setup-project.sh

echo
echo "Cloud development environment is ready."
echo "Sign in with: codex login --device-auth"
echo "Then run:     codex"

