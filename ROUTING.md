# Routing guide (paste into your main agent's instructions)

Delegate to the specialist that matches the task. Use `general-purpose` only when none fit.

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
| README, API docs, guides | documenter |

## Standard workflows
- **New feature**: explore -> research (if needed) -> architect -> planner -> coder / backend / database / ui-king -> tester -> reviewer -> security-reviewer (if it touches auth, input, or data) -> documenter
- **Bug fix**: explore -> debugger (reproduce, root cause, fix, regression test) -> tester -> reviewer
- **Refactor**: code-analyser -> architect -> planner -> coder -> tester -> reviewer
- **Release**: tester -> security-reviewer -> devops -> documenter
- **Unfamiliar codebase**: explore -> code-analyser -> documenter
- **Hard choice**: research -> decision-maker -> architect

## Rules
- Read-only agents (explore, planner, architect, analyser, code-analyser, research, decision-maker, reviewer, security-reviewer) never edit files.
- Run independent agents in parallel (for example explore and research).
- Always run tester and reviewer before calling work done.
- Destructive or production actions (deploy, delete, data changes) always need the user's approval.
