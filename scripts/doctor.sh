#!/usr/bin/env bash
set -u

print_version() {
  local label="$1"
  shift
  local output
  if command -v "$1" >/dev/null 2>&1; then
    if output="$("$@" 2>&1)"; then
      output="${output%%$'\n'*}"
      printf '%-12s %s\n' "$label" "${output:-available}"
    else
      printf '%-12s %s\n' "$label" 'installed but not runnable'
    fi
  else
    printf '%-12s %s\n' "$label" 'not installed'
  fi
}

echo 'Codex Cloud Starter environment'
echo '--------------------------------'
print_version 'git' git --version
print_version 'gh' gh --version
print_version 'node' node --version
print_version 'npm' npm --version
print_version 'python' python3 --version
print_version 'pip' python3 -m pip --version
print_version 'codex' codex --version
print_version 'rg' rg --version
print_version 'jq' jq --version

echo
if command -v codex >/dev/null 2>&1; then
  if codex login status >/dev/null 2>&1; then
    echo 'Codex authentication: ready'
  else
    echo 'Codex authentication: not signed in'
    echo 'Run: codex login --device-auth'
  fi
fi

if [[ -n "${OPENAI_API_KEY:-}" ]]; then
  echo 'OPENAI_API_KEY: set'
else
  echo 'OPENAI_API_KEY: not set (optional for ChatGPT sign-in)'
fi

