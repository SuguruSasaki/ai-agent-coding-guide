# TypeScript agent project policy and exceptions

These IDs are local guidance for TypeScript AI agents. They are not Google rules. Inspect existing project constraints before applying them; document a real incompatibility rather than silently overriding the guide.

| ID | Level | Policy and reason |
| --- | --- | --- |
| P-T01 | SHOULD | Use `async`/`await` for asynchronous I/O when it makes control flow clearer. Keep model, tool, and network I/O behind small boundaries so domain decisions can be tested without live services. Google does not prohibit `async`/`await`. |
| P-T02 | MUST | Treat external JSON, model responses, and tool results as `unknown` until runtime validation establishes their shape. Validate environment variables and messages before relying on their contents. Static types and `as` assertions do not validate runtime data. |
| P-T03 | REVIEW | Give each promise/task an owner. Propagate `AbortSignal` or the project's cancellation mechanism when a request can be cancelled; handle rejection and cleanup. Do not start unobserved async work unless its independent lifetime and error path are intentional. |
| P-T04 | SHOULD | Preserve recoverable error information. Add operation context while retaining the cause, and do not turn tool/network failures into `undefined`, `false`, or empty collections unless that result is part of an explicit API contract. |
| P-T05 | REVIEW | Use a named domain type or options object when a positional Boolean, string, or number makes call-site intent unclear or permits invalid combinations. A simple Boolean remains appropriate for an obvious binary choice. |
| P-T06 | SHOULD | Avoid speculative abstractions, type-level puzzles, and dependencies. Introduce interfaces and injectable boundaries where current callers or tests need them, not to satisfy a style pattern alone. |
| P-T07 | REVIEW | Test normal behavior, failure and cancellation paths where relevant, and the public API at a call site. Use controlled adapters for external effects; avoid tests that only restate implementation details. |

## Relationship to the Google guide

- The guide's [default-export rule](https://google.github.io/styleguide/tsguide.html#exports) assumes control over module entry points. A target framework may require a default export for a page, route, or configuration file. Use that export only where the framework contract requires it; use named exports elsewhere.
- Google permits namespaces for [external interoperability](https://google.github.io/styleguide/tsguide.html#use-modules-not-namespaces). Keep that narrow exception; do not use namespaces to organize ordinary application modules.
- Google permits `@ts-expect-error` in unit tests, though it [discourages it](https://google.github.io/styleguide/tsguide.html#ts-ignore). Prefer a targeted cast or documented lint suppression when it tests unchecked runtime input. Do not carry this test exception into production code.
- The guide does not prescribe this AI agent's runtime validation, cancellation, architecture, or test strategy. `P-T01` through `P-T07` add those requirements. Respect the project's existing formatter and package manager rather than installing or replacing them merely to imitate a Google example.
