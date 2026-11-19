#!/usr/bin/env bash
# Run the theme in an explicitly selected non-live development theme.
# Set SHOPIFY_DEV_THEME after confirming it is not the live theme.

set -euo pipefail
cd "$(dirname "$0")/.."

STORE="${SHOPIFY_STORE:-7yi0u9-ce.myshopify.com}"
THEME="${SHOPIFY_DEV_THEME:-}"

if [[ -z "$THEME" ]]; then
  echo "Set SHOPIFY_DEV_THEME to an explicitly chosen non-live theme ID or name." >&2
  exit 1
fi

if [[ "$THEME" == "150257500332" || "$THEME" == "Backyard Nests" ]]; then
  echo "Refusing to use the live theme for development preview." >&2
  exit 1
fi

shopify theme dev --store "$STORE" --theme "$THEME" --open "$@"
