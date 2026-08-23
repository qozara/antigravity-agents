#!/usr/bin/env bash
# ==============================================================================
# setup-symlinks.sh
#
# Configures global Antigravity IDE access for Qozara subagents, workflows & skills.
# Links all custom definitions directly to global directories (~/.gemini and ~/.antigravity)
# so they are automatically available in ALL workspaces without per-project setup.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/.agents"

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --global              Install/symlink globally across all Antigravity paths (Default)"
    echo "  --clean-global        Remove global Antigravity symlinks"
    echo "  -h, --help            Show this help message"
    echo ""
}

setup_global() {
    echo "=== Configuring Global Antigravity Access ==="
    echo "Source: ${SOURCE_DIR}"
    echo ""

    # 1. Global Skills Directories
    # Antigravity discovers global skills from ~/.gemini/antigravity/skills and ~/.gemini/config/skills
    local skill_targets=(
        "${HOME}/.gemini/antigravity/skills"
        "${HOME}/.gemini/config/skills"
        "${HOME}/.antigravity/skills"
    )

    for target_dir in "${skill_targets[@]}"; do
        mkdir -p "$target_dir"
        for skill_dir in "${SOURCE_DIR}/skills"/*; do
            if [ -d "$skill_dir" ]; then
                local skill_name
                skill_name="$(basename "$skill_dir")"
                ln -sfn "$skill_dir" "${target_dir}/${skill_name}"
            fi
        done
    done
    echo "✅ Global Skills configured in:"
    for target_dir in "${skill_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 2. Global Custom Agents / Personas Directories
    # Antigravity discovers custom agents globally from ~/.gemini/config/agents and ~/.gemini/antigravity/agents
    local agent_targets=(
        "${HOME}/.gemini/config/agents"
        "${HOME}/.gemini/antigravity/agents"
        "${HOME}/.gemini/antigravity/subagents"
    )

    for target_dir in "${agent_targets[@]}"; do
        mkdir -p "$target_dir"
        for agent_file in "${SOURCE_DIR}/agents"/*.md; do
            if [ -f "$agent_file" ]; then
                local agent_name
                agent_name="$(basename "$agent_file")"
                ln -sfn "$agent_file" "${target_dir}/${agent_name}"
            fi
        done
    done
    echo "✅ Global Agent Personas configured in:"
    for target_dir in "${agent_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 3. Global Workflows Directories
    # Antigravity discovers global workflows from ~/.gemini/config/global_workflows and ~/.gemini/antigravity/workflows
    local workflow_targets=(
        "${HOME}/.gemini/config/global_workflows"
        "${HOME}/.gemini/antigravity/workflows"
        "${HOME}/.antigravity/workflows"
    )

    for target_dir in "${workflow_targets[@]}"; do
        mkdir -p "$target_dir"
        for wf_file in "${SOURCE_DIR}/workflows"/*.md; do
            if [ -f "$wf_file" ]; then
                local wf_name
                wf_name="$(basename "$wf_file")"
                ln -sfn "$wf_file" "${target_dir}/${wf_name}"
            fi
        done
    done
    echo "✅ Global Workflows configured in:"
    for target_dir in "${workflow_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 4. ~/.antigravity/agents Root Symlink
    mkdir -p "${HOME}/.antigravity"
    ln -sfn "${SOURCE_DIR}" "${HOME}/.antigravity/agents"
    echo "✅ Root Symlink created: ${HOME}/.antigravity/agents -> ${SOURCE_DIR}"
    echo ""
    echo "🎉 Global configuration complete! All skills, personas, and workflows are globally available across every workspace."
}

clean_global() {
    echo "=== Cleaning Global Symlinks ==="
    for skill_dir in "${SOURCE_DIR}/skills"/*; do
        if [ -d "$skill_dir" ]; then
            local skill_name
            skill_name="$(basename "$skill_dir")"
            rm -f "${HOME}/.gemini/antigravity/skills/${skill_name}"
            rm -f "${HOME}/.gemini/config/skills/${skill_name}"
            rm -f "${HOME}/.antigravity/skills/${skill_name}"
        fi
    done

    for agent_file in "${SOURCE_DIR}/agents"/*.md; do
        if [ -f "$agent_file" ]; then
            local agent_name
            agent_name="$(basename "$agent_file")"
            rm -f "${HOME}/.gemini/config/agents/${agent_name}"
            rm -f "${HOME}/.gemini/antigravity/agents/${agent_name}"
            rm -f "${HOME}/.gemini/antigravity/subagents/${agent_name}"
        fi
    done

    for wf_file in "${SOURCE_DIR}/workflows"/*.md; do
        if [ -f "$wf_file" ]; then
            local wf_name
            wf_name="$(basename "$wf_file")"
            rm -f "${HOME}/.gemini/config/global_workflows/${wf_name}"
            rm -f "${HOME}/.gemini/antigravity/workflows/${wf_name}"
            rm -f "${HOME}/.antigravity/workflows/${wf_name}"
        fi
    done

    rm -f "${HOME}/.antigravity/agents"
    echo "✅ Global symlinks cleaned."
}

if [ $# -eq 0 ] || [ "${1:-}" = "--global" ]; then
    setup_global
elif [ "$1" = "--clean-global" ]; then
    clean_global
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    print_usage
else
    echo "Unknown option: $1"
    print_usage
    exit 1
fi
