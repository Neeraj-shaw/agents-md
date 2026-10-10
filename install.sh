#!/usr/bin/env bash
# Usage: ./install.sh [target-dir]
# Default target is ./.zcode/agents (project level). Change it to match zcode's agents folder.
# For user-level install try: ./install.sh ~/.zcode/agents
set -e
TARGET="${1:-.zcode/agents}"
mkdir -p "$TARGET"
cp "$(dirname "$0")"/agents/*.md "$TARGET"/
echo "Installed $(ls "$(dirname "$0")"/agents/*.md | wc -l) agents to $TARGET"
