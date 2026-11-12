# Paste this into your project's CLAUDE.md or AGENTS.md

## Subagents
Delegate to the specialist that fits. Run independent agents in parallel.
- explore: where is X, how is X used
- research: verified, current docs and library options
- architect: structure, tradeoffs, and choosing between options
- planner: goal -> ordered steps; unclear requirements -> acceptance criteria
- coder: implement one defined change
- backend: APIs, auth, jobs | database: schema, queries, migrations | ui-king: pages, components, accessibility
- debugger: root cause of a bug, or "why is this happening?"
- tester: write and run tests
- reviewer: review a diff, or assess existing code
- security-reviewer: security audit | devops: CI/CD, Docker, infra | documenter: README, API docs, ADRs

Rules: run tester and reviewer before calling work done. Deploys, deletes, and data changes need the user's approval.
Subagents start with a blank context, so every handoff needs a brief:

    Goal: <one-sentence outcome>
    Context: <paths, error text, what is already known or ruled out>
    Constraints: <stack, do-not-touch files, approvals needed>
    Done when: <observable check>

## Typical flows
- New feature: explore -> architect -> planner -> coder/backend/database/ui-king -> tester -> reviewer
- Bug: explore -> debugger (fix + regression test) -> reviewer
- Refactor: reviewer (assess) -> planner -> coder -> tester -> reviewer
- Release: tester -> security-reviewer -> devops -> documenter
