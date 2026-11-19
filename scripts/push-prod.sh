#!/usr/bin/env bash
# Push local theme files to BYN PROD (live theme).
# ⚠️  This pushes DIRECTLY to the live storefront — review your changes first.
# Run from the theme root: ./scripts/push-prod.sh
# To push only specific files: ./scripts/push-prod.sh --only templates/product.json

set -e
cd "$(dirname "$0")/.."

STORE="${SHOPIFY_STORE:-7yi0u9-ce.myshopify.com}"
THEME="${THEME_ID:-BYN PROD}"

echo "⚠️  Pushing to LIVE theme: $THEME on $STORE"
echo "Press Ctrl+C within 5 seconds to cancel..."
sleep 5

shopify theme push --store "$STORE" --theme "$THEME" "$@"
