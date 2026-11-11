#!/usr/bin/env bash
# ==============================================================================
# setup-symlinks.sh
#
# Configures global Google Antigravity access (App, IDE, and CLI) for
# rules, skills (slash-invocable workflows), custom subagents, lifecycle hooks,
# and deterministic Git pre-push hooks across all workspaces.
#
# Cross-Machine Replicable: Uses standard POSIX paths and dynamic $HOME.
# Works out-of-the-box on macOS and Linux without hardcoded user directories.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/.agents"

# Default to sibling repositories directory (or configure via ANTIGRAVITY_PROJECTS_DIR or --projects-dir)
PROJECTS_ROOT="${ANTIGRAVITY_PROJECTS_DIR:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --global                  Symlink rules, skills, subagents, hooks & git hooks globally (Default)"
    echo "  --projects-dir <dir>      Specify target directory containing Git repositories for pre-push hooks"
    echo "                            (Defaults to sibling directory: ${PROJECTS_ROOT})"
    echo "  --install-git-hooks       Install deterministic pre-push hook into Git repos in target directory"
    echo "  --clean-global            Remove global Antigravity symlinks"
    echo "  -h, --help                Show this help message"
    echo ""
}

ensure_executable() {
    chmod +x "${SOURCE_DIR}/skills/predeploy-gate/scripts/verify-gates.sh" 2>/dev/null || true
    chmod +x "${SOURCE_DIR}/scripts/pre-tool-guard.sh" 2>/dev/null || true
    chmod +x "${SOURCE_DIR}/scripts/git-pre-push.sh" 2>/dev/null || true
}

install_git_hooks() {
    echo "=== Installing Deterministic Git pre-push Hooks ==="
    echo "Target Directory: ${PROJECTS_ROOT}"
    ensure_executable
    local count=0
    if [ -d "${PROJECTS_ROOT}" ]; then
        while IFS= read -r -d '' git_dir; do
            local repo_dir
            repo_dir="$(dirname "$git_dir")"
            mkdir -p "${git_dir}/hooks"
            ln -sfn "${SOURCE_DIR}/scripts/git-pre-push.sh" "${git_dir}/hooks/pre-push"
            echo "   - Linked pre-push hook -> ${repo_dir}"
            count=$((count + 1))
        done < <(find "${PROJECTS_ROOT}" -maxdepth 3 -name ".git" -type d -print0 2>/dev/null)
    fi
    echo "✅ Installed deterministic pre-push hooks across ${count} repositories."
    echo ""
}

setup_global() {
    echo "=== Configuring Global Google Antigravity SDLC Environment ==="
    echo "Source: ${SOURCE_DIR}"
    echo "Home:   ${HOME}"
    echo ""
    ensure_executable

    # 1. Global Rules (~/.gemini/config/rules/*.md)
    local rule_targets=(
        "${HOME}/.gemini/config/rules"
    )
    for target_dir in "${rule_targets[@]}"; do
        mkdir -p "$target_dir"
        for rule_file in "${SOURCE_DIR}/rules"/*.md; do
            if [ -f "$rule_file" ]; then
                ln -sfn "$rule_file" "${target_dir}/$(basename "$rule_file")"
            fi
        done
    done
    echo "✅ Global Rules (always_on invariants) configured in:"
    for target_dir in "${rule_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 2. Global Skills & Slash-Command Workflows (~/.gemini/config/skills/<name>/SKILL.md)
    # Antigravity App/IDE/CLI share ~/.gemini/config/skills; CLI also checks ~/.gemini/antigravity-cli/skills and ~/.gemini/skills
    local skill_targets=(
        "${HOME}/.gemini/config/skills"
        "${HOME}/.gemini/antigravity-cli/skills"
        "${HOME}/.gemini/skills"
        "${HOME}/.gemini/antigravity/skills"
    )
    for target_dir in "${skill_targets[@]}"; do
        mkdir -p "$target_dir"
        for skill_dir in "${SOURCE_DIR}/skills"/*; do
            if [ -d "$skill_dir" ]; then
                ln -sfn "$skill_dir" "${target_dir}/$(basename "$skill_dir")"
            fi
        done
    done
    echo "✅ Global Skills & Slash Workflows (/feature-lifecycle, /refactor-lifecycle, /bugfix-lifecycle, /predeploy-gate) configured in:"
    for target_dir in "${skill_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 3. Global Custom Subagents (~/.gemini/config/agents/*.md)
    local agent_targets=(
        "${HOME}/.gemini/config/agents"
        "${HOME}/.gemini/antigravity/agents"
    )
    for target_dir in "${agent_targets[@]}"; do
        mkdir -p "$target_dir"
        # Remove any obsolete webchatbot symlinks
        rm -f "${target_dir}/engineer-webchatbot.md" "${target_dir}/engineer-webchatbot.md.bak"
        for agent_file in "${SOURCE_DIR}/agents"/*.md; do
            if [ -f "$agent_file" ]; then
                ln -sfn "$agent_file" "${target_dir}/$(basename "$agent_file")"
            fi
        done
    done
    echo "✅ Global Custom Subagents (@architect [pro], @engineer [flash], @tester [flash], @analyst [flash], @designer [flash]) configured in:"
    for target_dir in "${agent_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 4. Global Lifecycle Hooks (~/.gemini/config/hooks.json & scripts)
    mkdir -p "${HOME}/.gemini/config/scripts"
    ln -sfn "${SOURCE_DIR}/hooks.json" "${HOME}/.gemini/config/hooks.json"
    for script_file in "${SOURCE_DIR}/scripts"/*.sh; do
        if [ -f "$script_file" ]; then
            ln -sfn "$script_file" "${HOME}/.gemini/config/scripts/$(basename "$script_file")"
        fi
    done
    echo "✅ Global Lifecycle Hooks configured in:"
    echo "   - ${HOME}/.gemini/config/hooks.json"
    echo "   - ${HOME}/.gemini/config/scripts/"
    echo ""

    # 5. Legacy Workflows Compatibility (~/.gemini/config/workflows/*.md)
    local workflow_targets=(
        "${HOME}/.gemini/config/workflows"
        "${HOME}/.gemini/antigravity/workflows"
    )
    for target_dir in "${workflow_targets[@]}"; do
        mkdir -p "$target_dir"
        for wf_file in "${SOURCE_DIR}/workflows"/*.md; do
            if [ -f "$wf_file" ]; then
                ln -sfn "$wf_file" "${target_dir}/$(basename "$wf_file")"
            fi
        done
    done
    echo "✅ Legacy Workflows backward-compatibility configured in:"
    for target_dir in "${workflow_targets[@]}"; do
        echo "   - ${target_dir}"
    done
    echo ""

    # 6. Install Git pre-push hooks across workspace repositories
    install_git_hooks

    echo "🎉 Global Antigravity configuration complete!"
}

clean_global() {
    echo "=== Cleaning Global Antigravity Symlinks ==="
    for rule_file in "${SOURCE_DIR}/rules"/*.md; do
        [ -f "$rule_file" ] && rm -f "${HOME}/.gemini/config/rules/$(basename "$rule_file")"
    done
    for skill_dir in "${SOURCE_DIR}/skills"/*; do
        if [ -d "$skill_dir" ]; then
            local skill_name
            skill_name="$(basename "$skill_dir")"
            rm -f "${HOME}/.gemini/config/skills/${skill_name}"
            rm -f "${HOME}/.gemini/antigravity-cli/skills/${skill_name}"
            rm -f "${HOME}/.gemini/skills/${skill_name}"
            rm -f "${HOME}/.gemini/antigravity/skills/${skill_name}"
        fi
    done
    for agent_file in "${SOURCE_DIR}/agents"/*.md; do
        if [ -f "$agent_file" ]; then
            local agent_name
            agent_name="$(basename "$agent_file")"
            rm -f "${HOME}/.gemini/config/agents/${agent_name}"
            rm -f "${HOME}/.gemini/antigravity/agents/${agent_name}"
        fi
    done
    rm -f "${HOME}/.gemini/config/hooks.json"
    rm -rf "${HOME}/.gemini/config/scripts"
    echo "✅ Global symlinks cleaned."
}

# Parse optional arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --projects-dir)
            PROJECTS_ROOT="$2"
            shift 2
            ;;
        --global)
            ACTION="global"
            shift
            ;;
        --install-git-hooks)
            ACTION="git-hooks"
            shift
            ;;
        --clean-global)
            ACTION="clean"
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            print_usage
            exit 1
            ;;
    esac
done

ACTION="${ACTION:-global}"

case "$ACTION" in
    global)
        setup_global
        ;;
    git-hooks)
        install_git_hooks
        ;;
    clean)
        clean_global
        ;;
esac
