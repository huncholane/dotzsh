#!/bin/bash

# Run by cron every 6 hours. Caches update status for shell startup to read.

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotzsh"
mkdir -p "$CACHE_DIR"

# Check for system updates
if command -v paru &>/dev/null; then
  paru -Qu > "$CACHE_DIR/system_updates" 2>/dev/null
elif command -v pacman &>/dev/null; then
  pacman -Qu > "$CACHE_DIR/system_updates" 2>/dev/null
elif command -v apt &>/dev/null; then
  apt list --upgradeable 2>/dev/null | tail -n +2 > "$CACHE_DIR/system_updates"
elif command -v dnf &>/dev/null; then
  dnf check-update 2>/dev/null > "$CACHE_DIR/system_updates"
fi

# Check for dotzsh updates
ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
if (cd "$ZDOTDIR" && git fetch origin &>/dev/null); then
  if (cd "$ZDOTDIR" && [ "$(git rev-parse HEAD)" != "$(git rev-parse '@{u}' 2>/dev/null)" ]); then
    echo "1" > "$CACHE_DIR/dotzsh_update"
  else
    rm -f "$CACHE_DIR/dotzsh_update"
  fi
fi
