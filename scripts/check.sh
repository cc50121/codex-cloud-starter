#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

log() {
  printf '[check] %s\n' "$*"
}

ran_check=false

if [[ -f package.json ]]; then
  ran_check=true
  has_node_script() {
    node -e "const p = require('./package.json'); process.exit(p.scripts?.[process.argv[1]] ? 0 : 1)" "$1"
  }

  if [[ -f pnpm-lock.yaml ]] && command -v pnpm >/dev/null 2>&1; then
    log "Running pnpm checks"
    for script in lint test build; do
      if has_node_script "$script"; then
        pnpm run "$script"
      fi
    done
  elif [[ -f yarn.lock ]] && command -v yarn >/dev/null 2>&1; then
    log "Running Yarn checks"
    for script in lint test build; do
      if has_node_script "$script"; then
        yarn run "$script"
      fi
    done
  else
    log "Running npm checks"
    for script in lint test build; do
      if has_node_script "$script"; then
        npm run "$script"
      fi
    done
  fi
fi

if [[ -d tests ]] || compgen -G 'test_*.py' >/dev/null || compgen -G '*_test.py' >/dev/null; then
  if command -v pytest >/dev/null 2>&1; then
    ran_check=true
    log "Running pytest"
    pytest
  fi
fi

if [[ -f go.mod ]] && command -v go >/dev/null 2>&1; then
  ran_check=true
  log "Running Go tests"
  go test ./...
fi

if [[ -f Cargo.toml ]] && command -v cargo >/dev/null 2>&1; then
  ran_check=true
  log "Running Rust tests"
  cargo test --locked
fi

if [[ "$ran_check" == false ]]; then
  log "No project-specific checks were detected"
fi

log "Checks complete"

