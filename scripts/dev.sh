#!/usr/bin/env bash
# Run the theme locally with hot reload. Opens a preview in the browser.
# Run from the theme root: ./scripts/dev.sh
# Edit Liquid, CSS, sections — changes reload automatically.

set -e
cd "$(dirname "$0")/.."

STORE="${SHOPIFY_STORE:-7yi0u9-ce.myshopify.com}"
# Use your existing BYN DEV theme so you don't create a new dev theme each time
THEME="${SHOPIFY_DEV_THEME:-BYN DEV (GitHub)}"

shopify theme dev --store "$STORE" --theme "$THEME" --open "$@"
