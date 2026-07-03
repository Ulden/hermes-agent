# Hermes Lite - Maintenance Guide

## Overview

Hermes Lite is a fork of [Hermes Agent](https://github.com/NousResearch/hermes-agent) 
that removes all multi-platform messaging gateway code, keeping only the local CLI and TUI interfaces.

## What Was Removed

| Component | Status | Notes |
|-----------|--------|-------|
| Desktop app (`apps/desktop/`) | Removed | Electron + React app |
| Web dashboard (`web/`) | Removed | FastAPI-based web UI |
| Gateway platforms (`gateway/platforms/`) | Removed | Telegram, Discord, Slack, WhatsApp, etc. |
| Gateway runner (`gateway/run.py`) | Removed | Messaging gateway entry point |
| Gateway session (`gateway/session.py`) | Removed | Session management for messaging |
| Optional skills (`optional-skills/`) | Removed | Heavy/niche skills |
| Tests for removed components | Removed | `tests/gateway/`, `tests/e2e/` |

## What Was Kept

| Component | Status | Notes |
|-----------|--------|-------|
| Core agent (`run_agent.py`) | Kept | AI conversation loop |
| CLI (`cli.py`, `hermes_cli/`) | Kept | Interactive CLI with all features |
| TUI (`ui-tui/`, `tui_gateway/`) | Kept | Ink-based terminal UI |
| Tools (`tools/`) | Kept | All core tools |
| Skills (`skills/`) | Kept | Built-in skills |
| Plugins (`plugins/`) | Kept | Plugin system (minus platform adapters) |
| Cron scheduler (`cron/`) | Kept | Scheduled jobs |
| Memory providers | Kept | honcho, mem0, etc. |

## Stubs

Some modules are kept as stubs to prevent import errors:

- `gateway/__init__.py` - Exports only config and session context utilities
- `hermes_cli/gateway.py` - Stub that prints "not available in lite version"
- `hermes_cli/gateway_windows.py` - Windows-specific gateway stub

## Sync Workflow

### Quick Start

```bash
# Dry-run to see what would happen
./scripts/sync_upstream.sh --dry-run

# Actually sync
./scripts/sync_upstream.sh
```

### Manual Steps

If the script fails or you prefer manual control:

```bash
# 1. Fetch upstream
git fetch upstream main

# 2. Merge
git merge upstream/main

# 3. Resolve conflicts (if any)
# Common conflicts:
#   - pyproject.toml: Keep "hermes-lite" name
#   - README.md: Keep lite description
#   - gateway/: Keep stub versions

# 4. Remove restored files
rm -rf apps/desktop apps/shared web
rm -rf gateway/run.py gateway/session.py gateway/platforms gateway/relay gateway/builtin_hooks
rm -rf optional-skills tests/gateway tests/e2e

# 5. Commit
git add -A
git commit -m "chore(lite): re-apply removals after upstream sync"

# 6. Verify
grep 'name = "hermes-lite"' pyproject.toml
grep -qi "hermes lite" README.md

# 7. Test
scripts/run_tests.sh

# 8. Push
git push origin main
```

## Key Files to Watch During Sync

### pyproject.toml
- Keep `name = "hermes-lite"`
- Keep `[all]` extra lean (no messaging deps)
- Keep `optional-skills` out of `[all]`

### README.md
- Keep lite-specific description
- Keep "What was removed" table

### gateway/__init__.py
- Keep stub version (don't let upstream restore full gateway)

### hermes_cli/gateway.py
- Keep stub version

## Testing After Sync

```bash
# Full test suite
scripts/run_tests.sh

# Quick smoke test
python -c "import run_agent; print('OK')"
python -c "import cli; print('OK')"
python -c "import model_tools; print('OK')"

# Check no gateway imports are broken
python -c "from gateway import GatewayConfig; print('OK')"
```

## Troubleshooting

### Merge Conflicts

If `git merge` produces conflicts, resolve them in favor of the lite version:

```bash
# For pyproject.toml: keep hermes-lite name
git checkout --ours pyproject.toml
# Then re-apply lite-specific changes

# For README.md: keep lite description
git checkout --ours README.md

# For gateway/: keep stub versions
git checkout --ours gateway/
```

### Tests Failing After Sync

1. Check if upstream added new tests for removed components:
   ```bash
   git diff upstream/main..HEAD -- tests/
   ```

2. Skip or remove tests for removed components

3. Check if upstream changed import paths that now reference removed modules

### Files Restored by Merge

Sometimes `git merge` restores deleted files. Remove them:

```bash
# Find files that exist in HEAD but not in upstream
git diff --name-only upstream/main..HEAD --diff-filter=A

# Remove the ones that shouldn't be in lite
```

## Versioning

Hermes Lite follows the same version as upstream, with a `-lite` suffix 
in the package name. The version in `pyproject.toml` should match the 
upstream version at the time of sync.

## Contributing

When contributing to Hermes Lite:

1. Make changes on top of the latest synced upstream
2. Ensure changes don't re-introduce removed components
3. Test with `scripts/run_tests.sh`
4. Document any lite-specific behavior

## Contact

For issues specific to the lite version, open an issue in the fork repository.
For upstream issues, report to [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent).
