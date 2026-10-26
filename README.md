# agents-md-pro

18 specialist subagents, each bundled with its own vetted skills. Upgraded from `Neeraj-shaw/agents-md`.

- **Agent prompts**: your originals plus an operating contract, role-specific pitfalls, escalation rules, a stricter team protocol, and a skill-selection protocol.
- **126 skills** from public repos (Cloudflare security-audit, Anthropic, obra/superpowers, Addy Osmani, Trail of Bits, Sentry, Supabase, Vercel, HashiCorp, wshobson, UI UX Pro Max), copied unmodified and pinned to a commit (`skills.json`).
- **Auto-pick**: each agent discovers installed skills in the harness skill library, loads the ones that match the task (preferred list per role), and reports `Skills used: ...`.
- **Install separately**: every `agents/<name>/` folder is self-contained.

## Install

```bash
./install.sh                                  # all 18 agents + skills into ./.claude   (Claude Code)
./install.sh --scope user                     # into ~/.claude
./install.sh --agents debugger,tester         # only some agents (skills included)
cd agents/security-reviewer && ./install.sh   # one agent alone, from its own folder
./install.sh --harness zcode                  # .zcode/agents + .zcode/skills (original target)
./install.sh --dry-run --list                 # preview
```

| `--harness` | Agents go to | Skills go to | Status |
|---|---|---|---|
| `claude` | `.claude/agents/*.md` | `.claude/skills/` | native format |
| `zcode` | `.zcode/agents/*.md` | `.zcode/skills/` | same format; confirm ZCode reads these folders, else use `--agents-dir/--skills-dir` |
| `cursor` | `.cursor/agents/*.md` | `.cursor/skills/` | converted front matter |
| `opencode` | `.opencode/agent/*.md` | `.opencode/skills/` | converted (`mode: subagent`, tool toggles) |
| `codex` | `.codex/agents/*.toml` | `.agents/skills/` | converted to TOML; read-only agents get `sandbox_mode = "read-only"` |
| `copilot` | `.github/agents/*.agent.md` | `.github/skills/` | converted, tools mapped |
| `agents` | none | `.agents/skills/` | skills only (open standard folder) |

Claude Code and the Codex TOML schema were checked against current docs. The Cursor, OpenCode, Copilot, and ZCode adapters are best effort: install one agent first and use `--agents-dir/--skills-dir` to override paths.

## How skills are picked

1. Install skills into the harness library (the installer does this).
2. Each agent starts by listing skill names and descriptions, then loads only matching ones (three or fewer).
3. Optional `--preload` (Claude Code, ZCode) adds a `skills:` list so the agent starts with its skills fully injected. Costs more context per run, removes discovery.

Claude Code subagents do not inherit skill descriptions from the main session, so the prompts include their own discovery step and the `Skill` tool. If your harness rejects `Skill` in `tools:`, delete that word.

## Safety

Skills are third-party instructions and scripts. The bundle was scanned for pipe-to-shell, base64 decode, `eval`, destructive deletes, and prompt-injection phrases. Hits were limited to security reference docs (attack examples), standard installers (`uv`, `fnm`), and shell helpers. Review `skills.json` and the folders before installing in sensitive repos. Upstream commits are pinned; update by re-copying from a newer commit after review.

## Contents
`agents/<name>/{<name>.md, skills/, SKILLS.md, install.sh}` - `ROUTING.md` (orchestrator block, delegation brief, workflows) - `skills.json` - `THIRD_PARTY_LICENSES/`
