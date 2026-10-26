#!/usr/bin/env bash
# agents-md-pro installer: subagents + their skills, for several agent harnesses.
# Works from the bundle root (all agents) or from inside one agent folder (just that agent).
# Needs only bash, sed, awk, cp. No network, no root.
set -euo pipefail

HARNESS="claude"; SCOPE="project"; ONLY=""; DO_AGENTS=1; DO_SKILLS=1
PRELOAD=0; FORCE=0; DRY=0; AGENTS_DIR=""; SKILLS_DIR=""; LIST=0

usage() { cat <<'U'
Usage: ./install.sh [options]

  --harness H     claude (default) | zcode | cursor | opencode | codex | copilot | agents
                  agents = skills only, into the open ".agents/skills" folder (Codex, Zed, Amp, and others read it)
  --scope S       project (default, current directory) | user (home directory)
  --agents a,b    install only these agents (bundle root only)
  --skills-only   install skills, not agent files
  --no-skills     install agent files only (they still auto-use any skills already in the harness library)
  --preload       Claude Code / ZCode only: add a `skills:` list so each agent starts with its skills fully loaded
                  (more context per run; default is on-demand discovery)
  --agents-dir D  override where agent files go
  --skills-dir D  override where skill folders go
  --force         overwrite existing agent files and skill folders (default: skip and report)
  --dry-run       print what would happen, change nothing
  --list          list agents and their skills, then exit
  -h, --help      this help
U
}

while [ $# -gt 0 ]; do
  case "$1" in
    --harness) HARNESS="$2"; shift 2;;
    --scope) SCOPE="$2"; shift 2;;
    --agents) ONLY="$2"; shift 2;;
    --skills-only) DO_AGENTS=0; shift;;
    --no-skills) DO_SKILLS=0; shift;;
    --preload) PRELOAD=1; shift;;
    --agents-dir) AGENTS_DIR="$2"; shift 2;;
    --skills-dir) SKILLS_DIR="$2"; shift 2;;
    --force) FORCE=1; shift;;
    --dry-run) DRY=1; shift;;
    --list) LIST=1; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown option: $1" >&2; usage; exit 2;;
  esac
done

HERE="$(cd "$(dirname "$0")" && pwd)"
if [ -d "$HERE/agents" ]; then
  AGENT_DIRS=""
  for d in "$HERE"/agents/*/; do
    n="$(basename "$d")"
    if [ -n "$ONLY" ] && ! printf ',%s,' "$ONLY" | grep -q ",$n,"; then continue; fi
    AGENT_DIRS="$AGENT_DIRS ${d%/}"
  done
else
  AGENT_DIRS="$HERE"
fi
[ -n "$(echo $AGENT_DIRS)" ] || { echo "No matching agents found." >&2; exit 1; }

agent_file() { ls "$1"/*.md 2>/dev/null | grep -v -E '/(README|SKILLS)\.md$' | head -1; }

if [ "$LIST" = 1 ]; then
  for d in $AGENT_DIRS; do
    f="$(agent_file "$d")"; n="$(basename "$f" .md)"
    printf '%s\n' "$n"
    [ -d "$d/skills" ] && for s in "$d"/skills/*/; do printf '    %s\n' "$(basename "$s")"; done
  done
  exit 0
fi

if [ "$SCOPE" = "user" ]; then BASE="$HOME"; else BASE="$(pwd)"; fi

# Resolve target folders per harness
EXT="md"; ADAPT="claude"
case "$HARNESS" in
  claude)   A=".claude/agents";  S=".claude/skills"; ADAPT="claude";;
  zcode)    A=".zcode/agents";   S=".zcode/skills";  ADAPT="claude";;
  cursor)   A=".cursor/agents";  S=".cursor/skills"; ADAPT="cursor";;
  opencode) if [ "$SCOPE" = "user" ]; then A=".config/opencode/agent"; S=".config/opencode/skills"; else A=".opencode/agent"; S=".opencode/skills"; fi; ADAPT="opencode";;
  codex)    A=".codex/agents";   S=".agents/skills"; ADAPT="codex"; EXT="toml";;
  copilot)  A=".github/agents";  S=".github/skills"; ADAPT="copilot"; EXT="agent.md";;
  agents)   A="";                S=".agents/skills"; DO_AGENTS=0;;
  *) echo "Unknown harness: $HARNESS" >&2; exit 2;;
esac
[ "$HARNESS" = "copilot" ] && [ "$SCOPE" = "user" ] && echo "Note: Copilot custom agents are repository-scoped; use --scope project or --agents-dir." >&2
[ -n "$AGENTS_DIR" ] || AGENTS_DIR="$BASE/$A"
[ -n "$SKILLS_DIR" ] || SKILLS_DIR="$BASE/$S"

say() { printf '%s\n' "$*"; }
run() { if [ "$DRY" = 1 ]; then say "  [dry-run] $*"; else "$@"; fi; }

fm_get() { # fm_get file key  -> value of a single-line front-matter key
  awk -v k="$2" 'BEGIN{n=0} /^---[ \t]*$/{n++; next} n==1 && index($0,k":")==1 {sub("^"k":[ \t]*",""); print; exit}' "$1"
}
body() { awk 'BEGIN{n=0} n>=2{print; next} /^---[ \t]*$/{n++}' "$1"; }
readonly_agent() { ! printf '%s' "$1" | grep -qE '(^|, )(Edit|Write)(,|$)'; }
has_tool() { printf '%s' "$1" | grep -qE "(^|, )$2(,|$)"; }
esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

emit_agent() { # emit_agent src dst skills_csv
  src="$1"; dst="$2"; skills="$3"
  name="$(fm_get "$src" name)"; desc="$(fm_get "$src" description)"; tools="$(fm_get "$src" tools)"; color="$(fm_get "$src" color)"
  case "$ADAPT" in
    claude)
      awk -v pre="$PRELOAD" -v skills="$skills" '
        BEGIN{n=0}
        /^---[ \t]*$/{n++; if(n==2 && pre==1 && skills!=""){print "skills:"; m=split(skills,a,","); for(i=1;i<=m;i++) if(a[i]!="") print "  - " a[i]} print; next}
        {print}' "$src" > "$dst";;
    cursor)
      { echo "---"; echo "name: $name"; echo "description: $desc"; echo "model: inherit"
        if readonly_agent "$tools"; then echo "readonly: true"; fi
        echo "---"; body "$src"; } > "$dst";;
    opencode)
      { echo "---"; echo "description: $desc"; echo "mode: subagent"; echo "tools:"
        has_tool "$tools" Edit || echo "  edit: false"
        has_tool "$tools" Write || echo "  write: false"
        has_tool "$tools" Bash || echo "  bash: false"
        has_tool "$tools" WebFetch || echo "  webfetch: false"
        echo "---"; body "$src"; } > "$dst";;
    copilot)
      t=""; add() { case ", $t, " in *", $1, "*) ;; *) t="${t:+$t, }$1";; esac; }
      has_tool "$tools" Read && add "'read'"; has_tool "$tools" Grep && add "'search'"
      has_tool "$tools" Edit && add "'edit'"; has_tool "$tools" Write && add "'edit'"
      has_tool "$tools" Bash && add "'execute'"
      { has_tool "$tools" WebSearch || has_tool "$tools" WebFetch; } && add "'web'"
      { echo "---"; echo "name: $name"; echo "description: $desc"; echo "tools: [$t]"; echo "---"; body "$src"; } > "$dst";;
    codex)
      sb="workspace-write"; readonly_agent "$tools" && sb="read-only"
      { echo "name = \"$(printf '%s' "$name" | tr '-' '_')\""
        echo "description = \"$(esc "$desc")\""
        echo "sandbox_mode = \"$sb\""
        echo "developer_instructions = '''"; body "$src"; echo "'''"; } > "$dst";;
  esac
}

installed=0; skipped=0; sk_in=0; sk_skip=0
for d in $AGENT_DIRS; do
  f="$(agent_file "$d")"; [ -n "$f" ] || continue
  n="$(basename "$f" .md)"
  skills_csv=""
  if [ -d "$d/skills" ]; then for s in "$d"/skills/*/; do skills_csv="${skills_csv:+$skills_csv,}$(basename "$s")"; done; fi
  say "== $n"
  if [ "$DO_AGENTS" = 1 ]; then
    out="$AGENTS_DIR/$n.$EXT"
    if [ -e "$out" ] && [ "$FORCE" = 0 ]; then say "  agent: exists, skipped ($out)"; skipped=$((skipped+1))
    else
      run mkdir -p "$AGENTS_DIR"
      if [ "$DRY" = 1 ]; then say "  [dry-run] write $out"; else emit_agent "$f" "$out" "$skills_csv"; say "  agent: $out"; fi
      installed=$((installed+1))
    fi
  fi
  if [ "$DO_SKILLS" = 1 ] && [ -d "$d/skills" ]; then
    run mkdir -p "$SKILLS_DIR"
    for s in "$d"/skills/*/; do
      sn="$(basename "$s")"; dest="$SKILLS_DIR/$sn"
      if [ -e "$dest" ] && [ "$FORCE" = 0 ]; then sk_skip=$((sk_skip+1)); continue; fi
      [ -e "$dest" ] && run rm -rf "$dest"
      run cp -R "${s%/}" "$dest"; sk_in=$((sk_in+1))
    done
    say "  skills: $(printf '%s' "$skills_csv" | tr ',' '\n' | grep -c .) wanted"
  fi
done
say ""
say "Agents installed: $installed (skipped existing: $skipped)  Skills copied: $sk_in (already present: $sk_skip)"
say "Agents -> ${AGENTS_DIR:-n/a}   Skills -> $SKILLS_DIR"
[ "$HARNESS" = "codex" ] && say "Codex: custom agents spawn only on request, e.g. 'Spawn the debugger agent to ...'."
say "Restart or reload your harness so it re-reads agents and skills."
