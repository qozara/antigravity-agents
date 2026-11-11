#!/usr/bin/env bash
# ==============================================================================
# git-pre-push.sh — Deterministic Git Pre-Push Hook
#
# Installed into .git/hooks/pre-push (or .husky/pre-push) to guarantee that
# neither an agent nor a manual push can bypass typecheck, test, security,
# and build gates.
# ==============================================================================

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"
VERIFY_SCRIPT="${HOME}/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh"

if [[ -x "$VERIFY_SCRIPT" ]]; then
  "$VERIFY_SCRIPT" "$REPO_ROOT"
else
  echo "Running fallback pre-push verification in ${REPO_ROOT}..."
  cd "$REPO_ROOT"
  if [[ -f "package.json" ]]; then
    npm audit --audit-level=high
    CI=true npm test
    npm run build --if-present
  fi
fi
