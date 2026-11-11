#!/usr/bin/env bash
# ==============================================================================
# verify-gates.sh — Deterministic Pre-Deploy Verification Gate Runner
#
# Automatically detects workspace tooling (TypeScript, Vitest/Jest, npm audit,
# build scripts, Git branch policy, and path/PII leakage) and runs deterministic
# checks. Exits non-zero on any gate failure to force agent self-correction.
# ==============================================================================

set -euo pipefail

WORKSPACE_DIR="${1:-$(pwd)}"
cd "$WORKSPACE_DIR"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: verify-gates.sh [WORKSPACE_DIR] [--skip-build] [--skip-tests]"
  echo "Runs deterministic SDLC quality gates: Branch Policy, PII/Path Leak Check, Typecheck, Lint, Tests, Security Audit, and Build."
  exit 0
fi

SKIP_BUILD=false
SKIP_TESTS=false
for arg in "$@"; do
  case "$arg" in
    --skip-build) SKIP_BUILD=true ;;
    --skip-tests) SKIP_TESTS=true ;;
  esac
done

echo "============================================================"
echo "🛡️  Running Deterministic SDLC Quality Gates"
echo "📁 Workspace: $(pwd)"
echo "============================================================"

# 1. Git Branch Protection Check
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  CURRENT_BRANCH="$(git branch --show-current || true)"
  if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" ]]; then
    echo "❌ [GATE 1 FAILED] Direct work on protected branch '${CURRENT_BRANCH}' is forbidden."
    echo "   -> Checkout a dedicated branch: git checkout -b feature/<name> | fix/<name> | refactor/<name>"
    exit 1
  fi
  echo "✅ [Gate 1: Branch Policy] Active branch: ${CURRENT_BRANCH:-detached}"

  # 2. Workstation Path & Generated Artifact Leakage Check on Staged/Modified Files
  CHANGED_FILES="$(git status --porcelain | awk '{print $2}' || true)"
  if [[ -n "$CHANGED_FILES" ]]; then
    for f in $CHANGED_FILES; do
      if [[ "$f" =~ \.(sqlite|sqlite3|ndjson|db)$ ]]; then
        echo "❌ [GATE 2 FAILED] Generated database/data artifact detected in git status: $f"
        exit 1
      fi
      if [[ -f "$f" && ! "$f" =~ setup-symlinks\.sh ]]; then
        if grep -En "(/Users/[a-zA-Z0-9_-]+|file:///Users/)" "$f" >/dev/null 2>&1; then
          echo "❌ [GATE 2 FAILED] Absolute workstation path leaked in file: $f"
          grep -En "(/Users/[a-zA-Z0-9_-]+|file:///Users/)" "$f" || true
          exit 1
        fi
      fi
    done
  fi
  echo "✅ [Gate 2: Hygiene & Zero Path Leakage] Clean"
fi

# 3. Node / TypeScript / Package Checks (if package.json exists)
if [[ -f "package.json" ]]; then
  has_script() {
    node -e "const pkg = require('./package.json'); process.exit(pkg.scripts && pkg.scripts['$1'] ? 0 : 1);" 2>/dev/null
  }

  # Gate 3: Typechecking
  if has_script "check"; then
    echo "⏳ [Gate 3: Typecheck] Running npm run check..."
    npm run check
    echo "✅ [Gate 3: Typecheck] Passed"
  elif has_script "typecheck"; then
    echo "⏳ [Gate 3: Typecheck] Running npm run typecheck..."
    npm run typecheck
    echo "✅ [Gate 3: Typecheck] Passed"
  elif [[ -f "tsconfig.json" ]]; then
    echo "⏳ [Gate 3: Typecheck] Running npx tsc --noEmit..."
    npx tsc --noEmit
    echo "✅ [Gate 3: Typecheck] Passed"
  fi

  # Gate 4: Linting (if present)
  if has_script "lint"; then
    echo "⏳ [Gate 4: Lint] Running npm run lint..."
    npm run lint
    echo "✅ [Gate 4: Lint] Passed"
  fi

  # Gate 5: Security Audit
  echo "⏳ [Gate 5: Security Audit] Running npm audit --audit-level=high..."
  npm audit --audit-level=high
  echo "✅ [Gate 5: Security Audit] Zero high/critical vulnerabilities"

  # Gate 6: Automated Tests
  if [[ "$SKIP_TESTS" == "false" ]]; then
    if has_script "test:predeploy"; then
      echo "⏳ [Gate 6: Tests] Running npm run test:predeploy..."
      npm run test:predeploy
      echo "✅ [Gate 6: Tests] Passed"
    elif has_script "test:all:non-interactive"; then
      echo "⏳ [Gate 6: Tests] Running npm run test:all:non-interactive..."
      npm run test:all:non-interactive
      echo "✅ [Gate 6: Tests] Passed"
    elif has_script "test"; then
      echo "⏳ [Gate 6: Tests] Running npm test..."
      CI=true npm test
      echo "✅ [Gate 6: Tests] Passed"
    fi
  fi

  # Gate 7: Build Verification
  if [[ "$SKIP_BUILD" == "false" ]] && has_script "build"; then
    echo "⏳ [Gate 7: Build] Running npm run build..."
    npm run build
    echo "✅ [Gate 7: Build] Passed"
  fi
fi

echo "============================================================"
echo "🎉 ALL DETERMINISTIC QUALITY GATES PASSED"
echo "============================================================"
