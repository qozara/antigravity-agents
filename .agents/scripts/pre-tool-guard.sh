#!/usr/bin/env bash
# ==============================================================================
# pre-tool-guard.sh — Antigravity PreToolUse Lifecycle Hook for run_command
#
# Reads Antigravity hook JSON payload from stdin.
# 1. Blocks direct `git commit` or `git push` to `main` / `master`.
# 2. Enforces deterministic verification gates before allowing `git push`.
# ==============================================================================

set -euo pipefail

PAYLOAD="$(cat)"

COMMAND_LINE="$(echo "$PAYLOAD" | node -e '
  let data = "";
  process.stdin.on("data", chunk => data += chunk);
  process.stdin.on("end", () => {
    try {
      const parsed = JSON.parse(data);
      console.log((parsed.toolCall && parsed.toolCall.args && parsed.toolCall.args.CommandLine) || "");
    } catch {
      console.log("");
    }
  });
')"

CWD_PATH="$(echo "$PAYLOAD" | node -e '
  let data = "";
  process.stdin.on("data", chunk => data += chunk);
  process.stdin.on("end", () => {
    try {
      const parsed = JSON.parse(data);
      const cwd = (parsed.toolCall && parsed.toolCall.args && parsed.toolCall.args.Cwd) || (parsed.workspacePaths && parsed.workspacePaths[0]) || process.cwd();
      console.log(cwd);
    } catch {
      console.log(process.cwd());
    }
  });
')"

if [[ -z "$COMMAND_LINE" ]]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Block direct push or commit on main/master
if [[ "$COMMAND_LINE" =~ git[[:space:]]+(commit|push) ]]; then
  if [[ -d "$CWD_PATH" ]]; then
    BRANCH="$(git -C "$CWD_PATH" branch --show-current 2>/dev/null || true)"
    if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]] || [[ "$COMMAND_LINE" =~ origin[[:space:]]+(main|master) ]]; then
      echo '{"decision": "deny", "reason": "Blocked by deterministic guard: Direct commits or pushes to main/master are forbidden. Create a feature/, fix/, or refactor/ branch first."}'
      exit 0
    fi
  fi
fi

# Run deterministic pre-deploy verification before git push
if [[ "$COMMAND_LINE" =~ git[[:space:]]+push ]]; then
  VERIFY_SCRIPT="${HOME}/.gemini/config/skills/predeploy-gate/scripts/verify-gates.sh"
  if [[ -x "$VERIFY_SCRIPT" && -d "$CWD_PATH" ]]; then
    if ! "$VERIFY_SCRIPT" "$CWD_PATH" >/tmp/antigravity_prepush_gate.log 2>&1; then
      FAIL_REASON="$(tail -n 15 /tmp/antigravity_prepush_gate.log | tr '\n' ' ' | sed 's/"/\\"/g')"
      echo "{\"decision\": \"deny\", \"reason\": \"Pre-push deterministic verification failed: ${FAIL_REASON}\"}"
      exit 0
    fi
  fi
fi

echo '{"decision": "allow"}'
