#!/usr/bin/env bash
# Installs universal subagents + all referenced skills (both YAML frontmatter and Markdown tables).
# Usage:
#   ./install.sh                                  # ./.claude (project scope)
#   ./install.sh --scope user                     # ~/.claude
#   ./install.sh --harness cursor                 # ./.cursor
#   ./install.sh --agents explore,coder,ui-king   # install subset
#   ./install.sh --clean                          # remove stale agents before copying
#   ./install.sh --dry-run
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
base=".claude"
scope="project"
only=""
dry=0
clean=0
adir=""
sdir=""

while [ $# -gt 0 ]; do
  case "$1" in
    --scope) scope="$2"; shift 2 ;;
    --harness) base=".${2#.}"; shift 2 ;; # claude, cursor, codex, zcode
    --agents) only="$2"; shift 2 ;;
    --agents-dir) adir="$2"; shift 2 ;;
    --skills-dir) sdir="$2"; shift 2 ;;
    --clean) clean=1; shift ;;
    --dry-run) dry=1; shift ;;
    -h|--help)
      echo "Usage: ./install.sh [--scope project|user] [--harness claude|cursor|codex|zcode] [--agents a,b] [--clean] [--dry-run]"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

root="$PWD/$base"
[ "$scope" = "user" ] && root="$HOME/$base"
adir="${adir:-$root/agents}"
sdir="${sdir:-$root/skills}"

run() {
  if [ "$dry" = 1 ]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

if [ "$clean" = 1 ] && [ -d "$adir" ]; then
  run rm -rf "$adir"
fi

run mkdir -p "$adir" "$sdir"

if [ -n "$only" ]; then
  IFS=',' read -r -a agents_list <<< "$only"
else
  agents_list=()
  for f in "$here/agents"/*.md; do
    [ -e "$f" ] || continue
    agents_list+=("$(basename "$f" .md)")
  done
fi

extract_skills() {
  local file="$1"
  grep -oE '^\| `[a-z0-9-]+` \|' "$file" 2>/dev/null | tr -d '|` ' || true
  awk '
    NR==1 && /^---$/ { in_yaml=1; next }
    in_yaml && /^---$/ { exit }
    in_yaml && /^skills:/ {
      sub(/^skills:[[:space:]]*/, "")
      gsub(/[\[\]"]/, "")
      gsub(/,/, " ")
      for (i=1; i<=NF; i++) print $i
    }
  ' "$file"
}

skills_tmp="$(mktemp)"
trap 'rm -f "$skills_tmp"' EXIT

for a in "${agents_list[@]}"; do
  src="$here/agents/$a.md"
  if [ ! -f "$src" ]; then
    echo "Error: No such agent: $a ($src)" >&2
    exit 1
  fi
  run cp "$src" "$adir/$a.md"
  extract_skills "$src" >> "$skills_tmp"
done

installed_skills=0
while IFS= read -r s; do
  [ -z "$s" ] && continue
  if [ -d "$here/skills/$s" ]; then
    run cp -R "$here/skills/$s" "$sdir/"
    installed_skills=$((installed_skills + 1))
  else
    echo "Warning: Skill '$s' referenced in agent but not found in $here/skills/$s" >&2
  fi
done < <(sort -u "$skills_tmp")

echo "Installed ${#agents_list[@]} agents -> $adir"
echo "Installed $installed_skills unique skills -> $sdir"
echo "Next: copy ORCHESTRATOR.md into your project's CLAUDE.md or AGENTS.md."
