#!/usr/bin/env bash
# Pull the confirmed BYN live theme into a clean, isolated worktree.
# Run from the theme root: ./scripts/pull-prod.sh
# Override only after confirming the target with `shopify theme list`.

set -euo pipefail
cd "$(dirname "$0")/.."

STORE="${SHOPIFY_STORE:-7yi0u9-ce.myshopify.com}"
THEME="${THEME_ID:-150257500332}"
"$PWD/scripts/require-clean-worktree.sh"
echo "Pulling live theme $THEME from $STORE into this clean worktree."
shopify theme pull --store "$STORE" --theme "$THEME" "$@"
