---
name: polyglot-backend-patterns
description: Idiomatic architecture, validation, concurrency, and testing patterns across TypeScript/Node/Hono, Python (FastAPI/Pydantic/uv), Go, and Rust.
---

# Polyglot Backend Engineering Patterns

## 1. TypeScript / Node.js / Hono
- Use `zod` or `@hono/zod-validator` at every route boundary; infer handler types directly from schemas.
- Prefer `unknown` over `any` in catch blocks and external JSON responses.

## 2. Python (FastAPI / Pydantic v2 / Asyncio)
- Use Pydantic v2 `model_validate` and `ConfigDict(extra="forbid")` on request models.
- Never call blocking synchronous I/O (`requests`, `time.sleep`, sync DB drivers) inside `async def` endpoints; use `httpx.AsyncClient`, `asyncio.sleep`, and async SQLAlchemy/asyncpg.

## 3. Go & Rust
- **Go:** Propagate `context.Context` as the first parameter; wrap errors with `fmt.Errorf("op: %w", err)`; guard goroutines with `errgroup.WithContext`.
- **Rust:** Use `thiserror` for library errors and `anyhow` for application boundaries; avoid `.unwrap()`/`.expect()` on request-handling paths.
