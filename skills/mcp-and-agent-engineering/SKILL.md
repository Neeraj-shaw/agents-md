---
name: mcp-and-agent-engineering
description: Patterns for building Model Context Protocol (MCP) servers, multi-agent orchestration graphs, structured tool-calling schemas, hybrid vector/SQLite memory, dynamic model routing, and adversarial prompt-injection defenses.
---

# MCP & Agent Engineering Patterns

## 1. MCP Server & Tool Contract Design
- **Narrow, Action-Oriented Tools:** Prefer separate `read_*`, `search_*`, and `mutate_*` tools over overloaded catch-all tools.
- **Explicit Tenant Binding:** Never trust `userId`, `orgId`, or `mailboxId` passed inside tool arguments unless verified against the authenticated MCP API key's allowed scope list on the server.
- **Bounded Context Payloads:** Cap list responses (default `limit = 20`, max `50`) and truncate raw bodies with a `hasMore` cursor so a single tool call cannot overflow the LLM context window.

## 2. Indirect Prompt-Injection Defense
- **Zero Short-String Bypass:** Never skip injection checks on short inputs (`if (text.length < 10) return false;` is an exploitable bypass for payloads like `Ignore all`).
- **Spotlight / Delimit Untrusted Data:** Wrap untrusted email bodies, web scrapes, and user files in explicit XML/JSON data envelopes with system instructions reminding the model that content inside the envelope is data, never instructions.
- **Human-in-the-Loop Gate for Side Effects:** Require explicit user confirmation or policy tokens before executing outbound email sends, destructive deletes, payments, or external webhooks.

## 3. Stream & Endpoint Safety
- **Abort Propagation:** Pass `request.signal` / `AbortController` into all LLM stream calls so switching conversations or closing tabs immediately cancels token generation.
- **SSRF Protection on Custom Base URLs:** When users configure custom OpenAI-compatible `baseURL` endpoints, parse with `new URL()`, enforce `protocol === "https:"`, and block localhost, link-local (`169.254.0.0/16`), and RFC1918 private networks.
