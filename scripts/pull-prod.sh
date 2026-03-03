#!/usr/bin/env bash
# Pull BYN PROD (live theme) into the current directory.
# Run from the theme root: ./scripts/pull-prod.sh
# If the theme name doesn't work, set THEME_ID: THEME_ID=123 ./scripts/pull-prod.sh

set -e
cd "$(dirname "$0")/.."

STORE="${SHOPIFY_STORE:-7yi0u9-ce.myshopify.com}"
THEME="${THEME_ID:-BYN PROD}"
shopify theme pull --store "$STORE" --theme "$THEME" "$@"
