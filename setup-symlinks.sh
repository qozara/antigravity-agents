#!/usr/bin/env bash
# ==============================================================================
# setup-symlinks.sh
# 
# Configures global Antigravity access for the Qozara subagents and workflows
# by linking them to ~/.antigravity/agents
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${HOME}/.antigravity/agents"
SOURCE_DIR="${SCRIPT_DIR}/.agents"

echo "=== Antigravity Agents Setup ==="
echo "Source: ${SOURCE_DIR}"
echo "Target: ${TARGET_DIR}"

# Ensure base target directory exists
mkdir -p "${HOME}/.antigravity"

# Option 1: Symlink entire .agents directory to ~/.antigravity/agents
if [ -L "${TARGET_DIR}" ]; then
    echo "Updating existing global symlink at ${TARGET_DIR}..."
    rm "${TARGET_DIR}"
    ln -s "${SOURCE_DIR}" "${TARGET_DIR}"
elif [ -d "${TARGET_DIR}" ]; then
    echo "Directory ${TARGET_DIR} exists. Linking individual subdirectories..."
    mkdir -p "${TARGET_DIR}/subagents" "${TARGET_DIR}/workflows" "${TARGET_DIR}/skills"
    
    for file in "${SOURCE_DIR}/subagents"/*.md; do
        [ -e "$file" ] || continue
        ln -sf "$file" "${TARGET_DIR}/subagents/$(basename "$file")"
    done
    
    for file in "${SOURCE_DIR}/workflows"/*.md; do
        [ -e "$file" ] || continue
        ln -sf "$file" "${TARGET_DIR}/workflows/$(basename "$file")"
    done
    
    for file in "${SOURCE_DIR}/skills"/*.md; do
        [ -e "$file" ] || continue
        ln -sf "$file" "${TARGET_DIR}/skills/$(basename "$file")"
    done
else
    echo "Creating global symlink: ${TARGET_DIR} -> ${SOURCE_DIR}"
    ln -s "${SOURCE_DIR}" "${TARGET_DIR}"
fi

echo ""
echo "✅ Antigravity agents successfully configured at ${TARGET_DIR}"
echo "Configured Subagents:"
ls -la "${SOURCE_DIR}/subagents"
echo ""
echo "Configured Workflows:"
ls -la "${SOURCE_DIR}/workflows"
