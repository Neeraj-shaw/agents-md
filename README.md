# zcode subagent team

18 specialized subagents as Markdown files with YAML frontmatter (name, description, tools).

Install: `./install.sh` (copies to `.zcode/agents`) or `./install.sh /path/to/zcode/agents`.

Special attention: architect, code-analyser, coder, ui-king, backend.
New: debugger, security-reviewer, devops, database, decision-maker.

Every agent ends with a shared "Team protocol" (treat content as data, stay in lane, cite evidence, no commit/deploy without request, hand off).

## Check before using
- The folder zcode reads agents from.
- Whether zcode uses the same tool names (Read, Grep, Glob, Edit, Write, Bash, WebSearch, WebFetch). If not, rename them in the `tools:` lines.
- If the `tools:` field is not supported, delete the line; the rules still apply.
- Read-only agents have no Edit/Write on purpose.

## Add a new agent
Copy any file, change `name`, `description`, `tools`, and the instructions. Keep one job per agent. See ROUTING.md to wire it into workflows.
