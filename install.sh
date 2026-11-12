#!/usr/bin/env bash
# Installs agents + the skills they use. Default: ./.claude (Claude Code, project scope).
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
base=".claude"; scope="project"; only=""; dry=0; adir=""; sdir=""
while [ $# -gt 0 ]; do
  case "$1" in
    --scope) scope="$2"; shift 2;;
    --harness) base=".$2"; shift 2;;          # claude (default) or zcode
    --agents) only="$2"; shift 2;;            # e.g. debugger,tester
    --agents-dir) adir="$2"; shift 2;;
    --skills-dir) sdir="$2"; shift 2;;
    --dry-run) dry=1; shift;;
    -h|--help) sed -n 2,2p "$0"; echo "Options: --scope project|user  --harness claude|zcode  --agents a,b  --agents-dir D  --skills-dir D  --dry-run"; exit 0;;
    *) echo "Unknown option: $1" >&2; exit 1;;
  esac
done
root="$PWD/$base"; [ "$scope" = "user" ] && root="$HOME/$base"
adir="${adir:-$root/agents}"; sdir="${sdir:-$root/skills}"
if [ -n "$only" ]; then list="$(echo "$only" | tr ',' ' ')"; else list="$(cd "$here/agents" && ls *.md | sed 's/\.md$//')"; fi
run() { if [ "$dry" = 1 ]; then echo "[dry-run] $*"; else "$@"; fi; }
run mkdir -p "$adir" "$sdir"
skills=""
for a in $list; do
  [ -f "$here/agents/$a.md" ] || { echo "No such agent: $a" >&2; exit 1; }
  run cp "$here/agents/$a.md" "$adir/$a.md"
  skills="$skills $(grep -oE '^\| `[a-z0-9-]+` \|' "$here/agents/$a.md" | tr -d '|` ')"
done
for s in $(echo $skills | tr ' ' '\n' | sort -u); do run cp -R "$here/skills/$s" "$sdir/"; done
echo "Agents -> $adir"; echo "Skills -> $sdir ($(echo $skills | tr ' ' '\n' | sort -u | wc -l) installed)"
echo "Next: paste ORCHESTRATOR.md into your CLAUDE.md or AGENTS.md."
