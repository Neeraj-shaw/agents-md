# What changed vs agents-md-pro

| | Before | After |
|---|---|---|
| Agents | 18 | 15 |
| Skills | 126 (167 copies, 12 MB) | 42 (one copy each, ~2 MB total) |
| Prompt words | ~20,900 | ~12,600 (incl. skill tables) |

## Removed or merged
- `general-purpose`: Claude Code already ships one; this copy shadowed it and its own prompt warned against it.
- `analyser` -> merged into `debugger` (diagnose-only mode) and `planner` (requirements mode).
- `code-analyser` -> merged into `reviewer` (assess mode).
- `decision-maker` is kept as its own agent (picks between options); `architect` stays the code-structure and roadmap agent.
- Per-agent boilerplate: the 5-step "Skill library" block and the long "Team protocol" (about 9,000 words across 18 files, 45% of all prompt text) replaced by a 4-line Team rules block.
- `Skill` removed from `tools:` (not needed; skills are read from the skills folder). `verification-before-completion` is preloaded for coder, debugger, tester via `skills:`.
- Skills dropped: 87. Reasons are in `skills.json` under `removed_restore_info`, each with repo, path and pinned commit so you can restore any of them. Groups: stack-specific (Python, Go, K8s, Terraform, Vercel, Supabase...), duplicates of a kept skill, advanced patterns that push beginners to over-engineer (saga, CQRS, event store, microservices), and very large audit tooling (ui-ux-pro-max 3.7 MB, security-audit, Trail of Bits).
- All remaining skills are MIT or Apache-2.0 (the CC-BY-SA and MPL ones were removed).
- Installer: one script instead of 19; Cursor/OpenCode/Copilot/Codex converters removed because they were unverified. Use `--agents-dir/--skills-dir` for other tools.
- `ui-king` rebuilt as a design-director agent. `ui-ux-pro-max` (3.7 MB, Python scripts) removed: two independent side-by-side tests rated its output the most generic, while Impeccable and Anthropic's `frontend-design` scored highest. New UI skill stack: `impeccable` (Apache-2.0, design playbooks: new-work, shape, critique, audit, polish, layout, type, color, motion, harden, adapt), `frontend-design`, `web-interface-guidelines` (Vercel rules, pinned local snapshot instead of fetching from the web each run), `wcag-audit-patterns`, `frontend-ui-engineering`, `tailwind-design-system`, `webapp-testing` (Playwright screenshots to verify the result).
- Impeccable is vendored without its `scripts/` folder (it downloads and runs a binary) and without the live/generate/hooks/doctor references that need it. Its own SKILL.md has a fallback for this. See `skills/impeccable/LOCAL-CHANGES.md`.
- Shared team protocol now lives in `ORCHESTRATOR.md` (paste into CLAUDE.md/AGENTS.md); Claude Code subagents read CLAUDE.md.

## Not changed
Skill contents are untouched upstream copies. Agent role prompts keep their original process, output format, pitfalls and escalation rules.
