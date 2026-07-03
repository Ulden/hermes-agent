#!/usr/bin/env bash
# =============================================================================
# Hermes Lite - Sync Script
# =============================================================================
# Purpose: Pull latest changes from upstream Hermes Agent and re-apply
#          the lite version removals automatically.
#
# Usage:   ./scripts/sync_upstream.sh [--dry-run] [--force]
#
# This script automates the workflow of:
# 1. Fetching upstream changes
# 2. Merging or rebasing onto upstream/main
# 3. Re-applying lite removals (files/dirs that should not exist in lite)
# 4. Committing the result
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
UPSTREAM_REMOTE="upstream"
UPSTREAM_BRANCH="main"
LITE_BRANCH="main"
DRY_RUN=false
FORCE=false

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run] [--force]"
            exit 1
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Colors for output
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
log_info "Starting Hermes Lite upstream sync..."

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    log_error "Not in a git repository"
    exit 1
fi

# Check if upstream remote exists
if ! git remote get-url "$UPSTREAM_REMOTE" > /dev/null 2>&1; then
    log_error "Upstream remote '$UPSTREAM_REMOTE' not found."
    log_info "Add it with: git remote add upstream https://github.com/NousResearch/hermes-agent.git"
    exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    if [ "$FORCE" = false ]; then
        log_error "You have uncommitted changes. Commit or stash them first."
        log_info "Use --force to override (not recommended)"
        exit 1
    else
        log_warn "Force mode: ignoring uncommitted changes"
    fi
fi

# ---------------------------------------------------------------------------
# Step 1: Fetch upstream
# ---------------------------------------------------------------------------
log_info "Fetching upstream/$UPSTREAM_BRANCH..."
if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] Would run: git fetch $UPSTREAM_REMOTE $UPSTREAM_BRANCH"
else
    git fetch "$UPSTREAM_REMOTE" "$UPSTREAM_BRANCH"
    log_success "Fetched upstream/$UPSTREAM_BRANCH"
fi

# ---------------------------------------------------------------------------
# Step 2: Check if there's anything new
# ---------------------------------------------------------------------------
LOCAL_HASH=$(git rev-parse HEAD)
UPSTREAM_HASH=$(git rev-parse "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH")

if [ "$LOCAL_HASH" = "$UPSTREAM_HASH" ]; then
    log_success "Already up to date with upstream/$UPSTREAM_BRANCH"
    exit 0
fi

log_info "Local:  $LOCAL_HASH"
log_info "Upstream: $UPSTREAM_HASH"

# ---------------------------------------------------------------------------
# Step 3: Merge upstream changes
# ---------------------------------------------------------------------------
if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] Would merge $UPSTREAM_REMOTE/$UPSTREAM_BRANCH into current branch"
else
    log_info "Merging upstream/$UPSTREAM_BRANCH..."
    if ! git merge "$UPSTREAM_REMOTE/$UPSTREAM_BRANCH" --no-edit -m "merge: sync upstream and rebuild Lite version"; then
        log_error "Merge failed. Please resolve conflicts manually."
        log_info "Common conflicts to expect:"
        log_info "  - pyproject.toml: Keep 'hermes-lite' name, keep removed deps out of [all]"
        log_info "  - README.md: Keep lite version description"
        log_info "  - gateway/: Keep stub versions"
        exit 1
    fi
    log_success "Merged upstream changes"
fi

# ---------------------------------------------------------------------------
# Step 4: Re-apply Lite removals
# ---------------------------------------------------------------------------
log_info "Re-applying lite removals..."

# Define what should be removed in lite version
REMOVE_DIRS=(
    "apps/desktop"
    "apps/shared"
    "web"
    "gateway/run.py"
    "gateway/session.py"
    "gateway/platforms"
    "gateway/relay"
    "gateway/builtin_hooks"
    "optional-skills"
    "tests/gateway"
    "tests/e2e"
)

# Files that should be replaced with stubs if upstream restores them
STUB_FILES=(
    "gateway/__init__.py"
    "hermes_cli/gateway.py"
    "hermes_cli/gateway_windows.py"
)

if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] Would check and remove the following if they exist:"
    for dir in "${REMOVE_DIRS[@]}"; do
        if [ -e "$dir" ]; then
            log_info "[DRY-RUN]   Would remove: $dir"
        fi
    done
    
    log_info "[DRY-RUN] Would ensure stubs exist for:"
    for file in "${STUB_FILES[@]}"; do
        log_info "[DRY-RUN]   Would check: $file"
    done
else
    removed_something=false
    
    # Remove directories/files
    for dir in "${REMOVE_DIRS[@]}"; do
        if [ -e "$dir" ]; then
            log_info "Removing: $dir"
            rm -rf "$dir"
            git add -A "$dir" 2>/dev/null || true
            removed_something=true
        fi
    done
    
    # Ensure stubs are in place
    for file in "${STUB_FILES[@]}"; do
        if [ -f "$file" ]; then
            if ! head -5 "$file" | grep -qi "stub\|lite"; then
                log_warn "$file exists but may not be a stub. Review manually."
            fi
        fi
    done
    
    if [ "$removed_something" = true ]; then
        git add -A
        if ! git diff --cached --quiet; then
            git commit -m "chore(lite): re-apply removals after upstream sync"
            log_success "Committed lite removals"
        fi
    fi
fi

# ---------------------------------------------------------------------------
# Step 5: Verify critical files
# ---------------------------------------------------------------------------
log_info "Verifying lite version integrity..."

if [ "$DRY_RUN" = false ]; then
    if ! grep -q 'name = "hermes-lite"' pyproject.toml; then
        log_warn "pyproject.toml may have lost 'hermes-lite' name. Check manually."
    fi
    
    if ! grep -qi "hermes lite" README.md; then
        log_warn "README.md may have lost lite references. Check manually."
    fi
fi

# ---------------------------------------------------------------------------
# Step 6: Summary
# ---------------------------------------------------------------------------
log_success "Sync complete!"

if [ "$DRY_RUN" = true ]; then
    log_info "This was a dry-run. No changes were made."
    log_info "Run without --dry-run to apply changes."
else
    NEW_HASH=$(git rev-parse HEAD)
    log_info "New HEAD: $NEW_HASH"
    log_info "Changes since before sync:"
    git log --oneline "$LOCAL_HASH..$NEW_HASH" | head -20
    
    log_info ""
    log_info "Next steps:"
    log_info "  1. Review the changes: git diff $LOCAL_HASH..HEAD"
    log_info "  2. Run tests: scripts/run_tests.sh"
    log_info "  3. Push to origin: git push origin $LITE_BRANCH"
fi
