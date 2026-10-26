# Routing guide

Paste the **Orchestrator block** into your main agent's instructions (`AGENTS.md` or `CLAUDE.md`).
Subagents start with a blank context, so every delegation needs a **brief**.

## Orchestrator block

```
Delegate to the specialist that matches the task; use `general-purpose` only when none fits.
explore: where is X / how is X used | analyser: why is this happening, what exactly is needed
code-analyser: assess existing code | research: verified, current docs and options
decision-maker: choose between options | architect: structure, boundaries, tradeoffs
planner: goal -> ordered steps | backend: APIs, auth, jobs | database: schema, queries, migrations
ui-king: pages, components, a11y | coder: implement one defined change | debugger: root cause of a bug
tester: write and run tests | reviewer: review a diff | security-reviewer: security audit
devops: CI/CD, Docker, infra | documenter: README, API docs, ADRs
Rules: run independent agents in parallel. Always run tester and reviewer before calling work done.
Deploys, deletes, and data changes need the user's approval.
Subagents choose their own skills from the installed skill library; do not name skills in briefs unless required.
```

## Delegation brief (copy for every handoff)

```
Goal: <one sentence outcome>
Context: <paths, branch, error text, links; what you already know or ruled out>
Constraints: <stack, style, do-not-touch files, approvals needed>
Done when: <observable acceptance check>
Report: <format and length>
```

## Which agent

| Task | Agent |
|---|---|
| Where is X? How is X used? | explore |
| Why is this happening? What exactly do we need? Logs, data, requirements | analyser |
| Understand or assess existing code (structure, risk, dead code) | code-analyser |
| Look up docs, compare libraries, verify current best practice | research |
| Choose between options with clear criteria | decision-maker |
| Structural design, technology choice, tradeoffs | architect |
| Turn a goal into ordered steps | planner |
| APIs, auth, jobs, server logic | backend |
| Schema, queries, indexes, migrations | database |
| Pages, components, styling, accessibility | ui-king |
| Implement one defined change | coder |
| Find the root cause of a bug or flaky test | debugger |
| Write and run tests | tester |
| Review a diff before merge | reviewer |
| Security audit, secrets, dependency risk | security-reviewer |
| CI/CD, Docker, deploy, infrastructure | devops |
| README, API docs, ADRs, changelogs | documenter |
| Fits nothing above | general-purpose |

## Standard workflows
- **New feature**: explore -> research (if needed) -> architect -> planner -> coder / backend / database / ui-king -> tester -> reviewer -> security-reviewer (auth, input, data) -> documenter
- **Bug fix**: explore -> debugger (reproduce, root cause, fix, regression test) -> tester -> reviewer
- **Refactor**: code-analyser -> architect -> planner -> coder -> tester -> reviewer
- **Release**: tester -> security-reviewer -> devops -> documenter
- **Unfamiliar codebase**: explore -> code-analyser -> documenter
- **Hard choice**: research -> decision-maker -> architect
- **Incident**: analyser -> debugger -> devops -> documenter (postmortem)

## Rules
- Read-only agents (explore, planner, architect, analyser, code-analyser, research, decision-maker, reviewer) never edit files. security-reviewer never edits source; it may write audit reports outside the repo.
- Independent agents run in parallel (for example explore and research). Dependent steps run in order.
- Destructive or production actions (deploy, delete, data changes) always need the user's approval.
- Each agent ends with `Skills used: ...; missing: ...` and `Next: ...`. Use `Next:` to chain the workflow.
