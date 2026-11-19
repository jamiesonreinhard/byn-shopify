#!/usr/bin/env bash
# Shared guardrail for any command that syncs with a Shopify theme.

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this command from a Git worktree." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Refusing to sync a dirty worktree. Create an isolated worktree or commit/stash the current changes first." >&2
  exit 1
fi
