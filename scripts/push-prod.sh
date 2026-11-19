#!/usr/bin/env bash
# Push a reviewed release to the confirmed BYN live theme.
# This is intentionally fail-closed. Use only after the PDP release workflow
# has a fresh live baseline, preview verification, and explicit authorization.

set -euo pipefail
cd "$(dirname "$0")/.."

STORE="${SHOPIFY_STORE:-7yi0u9-ce.myshopify.com}"
THEME="${THEME_ID:-150257500332}"
"$PWD/scripts/require-clean-worktree.sh"

if [[ "${BYN_LIVE_RELEASE_APPROVED:-}" != "1" ]]; then
  echo "Refusing live push. Set BYN_LIVE_RELEASE_APPROVED=1 only after explicit production approval." >&2
  exit 1
fi

if [[ -z "${BYN_RELEASE_MANIFEST:-}" || ! -f "${BYN_RELEASE_MANIFEST}" ]]; then
  echo "Refusing live push. Set BYN_RELEASE_MANIFEST to the verified PDP release manifest." >&2
  exit 1
fi

echo "Pushing reviewed release to live theme $THEME on $STORE."

shopify theme push --store "$STORE" --theme "$THEME" "$@"
