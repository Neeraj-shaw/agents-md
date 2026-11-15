---
name: edge-and-serverless-patterns
description: Production patterns for Cloudflare Workers, Durable Objects (SQLite), Hono, R2, Neon Serverless Postgres, and Vercel Edge runtimes.
---

# Edge & Serverless Architecture Patterns

## 1. Cloudflare Workers & V8 Isolate Limits
- **128 MB Memory Ceiling:** Never decode multi-megabyte Base64 attachments via `atob()` + `Uint8Array.from(str, c => c.charCodeAt(0))`. Use `Buffer.from(base64, "base64")` under `nodejs_compat` or stream directly to R2.
- **2 MB Durable Object SQLite Cell Cap:** Store binary attachments > 256 KB in R2 and keep only metadata and content hashes in Durable Object SQLite or Neon Postgres.
- **Migration Concurrency Guard:** Always run Durable Object SQLite schema migrations inside `this.ctx.blockConcurrencyWhile(async () => { ... })` in the constructor.

## 2. Hybrid Edge SQLite + Cloud Postgres Consistency
- **Avoid Synchronous Dual-Writes:** Writing synchronously to both Durable Object SQLite and Neon Postgres creates split-brain state when the Worker times out mid-flight.
- **Transactional Outbox Pattern:** Commit synchronously to Durable Object SQLite (`sync_status = 'pending'`), schedule `this.ctx.storage.setAlarm(Date.now() + 1000)`, and batch-upsert to Neon inside `alarm()` using `ON CONFLICT (id) DO UPDATE`.

## 3. Outbound Socket & SMTP Hardening
- Wrap outbound SMTP/TCP sockets in `AbortSignal.timeout(15_000)`.
- Strip `\r` and `\n` from all sender names, subjects, and header fields to prevent SMTP CRLF header injection.
