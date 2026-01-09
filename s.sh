#!/usr/bin/env bash
set -euo pipefail

# Resolve script directory (works with symlinks)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$SCRIPT_DIR/hosts.yml"

ALIAS="${1:-}"

if [[ -z "$ALIAS" ]]; then
  echo "Usage: $(basename "$0") <host_alias>"
  exit 1
fi

if [[ ! -f "$CONFIG" ]]; then
  echo "Config not found: $CONFIG"
  exit 1
fi

get() {
  yq -r ".hosts.$ALIAS.$1 // \"\"" "$CONFIG"
}

HOSTNAME=$(get hostname)
USER=$(get user)
IDENTITY=$(get identity_file)
JUMP=$(get jump)
PASSWORD=$(get password)

if [[ -z "$HOSTNAME" || -z "$USER" ]]; then
  echo "Invalid or missing host config for '$ALIAS'"
  exit 1
fi

SSH_OPTS=(
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/dev/null
  -o ServerAliveInterval=30
  -o ServerAliveCountMax=3
)

[[ -n "$IDENTITY" ]] && SSH_OPTS+=(-i "$(eval echo "$IDENTITY")")

# Jump host
if [[ -n "$JUMP" ]]; then
  JUMP_HOST=$(yq -r ".hosts.$JUMP.hostname" "$CONFIG")
  JUMP_USER=$(yq -r ".hosts.$JUMP.user" "$CONFIG")

  [[ -z "$JUMP_HOST" || -z "$JUMP_USER" ]] && {
    echo "Invalid jump host '$JUMP'"
    exit 1
  }

  SSH_OPTS+=(-J "$JUMP_USER@$JUMP_HOST")
fi

# Password auth
if [[ -n "$PASSWORD" ]]; then
  exec sshpass -p "$PASSWORD" ssh "${SSH_OPTS[@]}" "$USER@$HOSTNAME"
else
  exec ssh "${SSH_OPTS[@]}" "$USER@$HOSTNAME"
fi