# Theme process: don’t overwrite Shopify UI work

Changes made in the **Shopify theme editor** (sections, settings, content) only exist in Shopify until we pull them. If we push from the repo without pulling first, we overwrite that work.

**Rule: always pull from Shopify before you push to Shopify.**

## Before you push to Shopify

1. **Pull first** (get the latest from the store):
   ```bash
   shopify theme pull
   ```
   Use `--development` if you’re syncing with a development theme, or `--theme <ID>` for a specific theme.

**Shortcut to pull BYN PROD (live):** from the theme root, run `./scripts/pull-prod.sh`. Use it before publishing BYN DEV so you don’t overwrite the designer’s work on PROD.

2. **Resolve any differences** between your code and what you pulled (e.g. in `config/settings_data.json`, templates). Commit.

3. **Then push** when you’re ready:
   ```bash
   shopify theme push
   ```

That way we never overwrite important work done in the Shopify UI.
