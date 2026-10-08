#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

log() {
  printf '[setup] %s\n' "$*"
}

warn() {
  printf '[setup] warning: %s\n' "$*" >&2
}

installed_anything=false

if [[ -f package.json ]]; then
  installed_anything=true
  if command -v corepack >/dev/null 2>&1; then
    corepack enable
  fi

  if [[ -f pnpm-lock.yaml ]]; then
    if command -v pnpm >/dev/null 2>&1; then
      log "Installing Node.js dependencies with pnpm"
      pnpm install --frozen-lockfile
    else
      warn "pnpm-lock.yaml exists, but pnpm is unavailable"
    fi
  elif [[ -f yarn.lock ]]; then
    if command -v yarn >/dev/null 2>&1; then
      log "Installing Node.js dependencies with Yarn"
      yarn install --immutable || yarn install --frozen-lockfile
    else
      warn "yarn.lock exists, but Yarn is unavailable"
    fi
  elif [[ -f package-lock.json || -f npm-shrinkwrap.json ]]; then
    log "Installing Node.js dependencies with npm ci"
    npm ci
  else
    log "Installing Node.js dependencies with npm"
    npm install
  fi
fi

if [[ -f uv.lock ]]; then
  installed_anything=true
  if command -v uv >/dev/null 2>&1; then
    log "Installing Python dependencies with uv"
    uv sync --frozen
  else
    warn "uv.lock exists, but uv is unavailable"
  fi
elif [[ -f poetry.lock ]]; then
  installed_anything=true
  if command -v poetry >/dev/null 2>&1; then
    log "Installing Python dependencies with Poetry"
    poetry install
  else
    warn "poetry.lock exists, but Poetry is unavailable"
  fi
elif [[ -f requirements.txt || -f requirements-dev.txt ]]; then
  installed_anything=true
  if [[ ! -d .venv ]]; then
    log "Creating Python virtual environment"
    python3 -m venv .venv
  fi
  # shellcheck disable=SC1091
  source .venv/bin/activate
  python -m pip install --upgrade pip
  if [[ -f requirements.txt ]]; then
    log "Installing requirements.txt"
    python -m pip install --requirement requirements.txt
  fi
  if [[ -f requirements-dev.txt ]]; then
    log "Installing requirements-dev.txt"
    python -m pip install --requirement requirements-dev.txt
  fi
fi

if [[ -f go.mod ]]; then
  installed_anything=true
  if command -v go >/dev/null 2>&1; then
    log "Downloading Go modules"
    go mod download
  else
    warn "go.mod exists, but Go is unavailable"
  fi
fi

if [[ -f Cargo.toml ]]; then
  installed_anything=true
  if command -v cargo >/dev/null 2>&1; then
    log "Fetching Rust crates"
    cargo fetch --locked
  else
    warn "Cargo.toml exists, but Rust is unavailable"
  fi
fi

if [[ "$installed_anything" == false ]]; then
  log "No supported dependency manifest found; nothing to install"
fi

log "Setup complete"

