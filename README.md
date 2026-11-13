# agents-md-lean

15 focused subagents plus 42 skills (MIT / Apache-2.0), pinned in `skills.json`.

    ./install.sh                      # into ./.claude (Claude Code)
    ./install.sh --scope user         # into ~/.claude
    ./install.sh --agents debugger,tester
    ./install.sh --dry-run

Then paste `ORCHESTRATOR.md` into your CLAUDE.md or AGENTS.md. See `CHANGES.md` for what was cut and why.
Each agent lists its skills in a table and reads one only when it fits the task. Third-party skills are instructions and scripts: skim them before using in sensitive repos.
