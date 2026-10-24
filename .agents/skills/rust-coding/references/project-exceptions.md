# Additional policies and exceptions for the Rust AI agent

`[P-...]` IDs identify project policies. For Google-derived rules, see [google-rust-style.md](google-rust-style.md). This repository does not yet contain a Cargo manifest or application code, so inspect the target project's implementation, runtime, and existing guidance before applying these policies.

| ID | Category | Policy and reason | Relationship to Google's guide |
| --- | --- | --- | --- |
| `P-C1` | SHOULD | Use async/await for asynchronous I/O in an AI agent built with Tokio. Where practical, separate business logic into synchronous functions and types that can be tested without I/O. | Do not apply Chromium's async ban. It is not a general Rust rule. |
| `P-C2` | REVIEW | Check for blocking I/O or expensive computation on async tasks, locks held across await points, task completion, errors, cancellation, and concurrency limits. | Adds Tokio-specific review questions beyond Google's general concurrency guidance. |
| `P-O1` | SHOULD | Avoid unnecessary `clone`, `Arc`, and `Rc`. Use them when justified by owned storage, task boundaries, or shared state. Compare runtime cost with lifetime complexity. | Consistent with Google's Ownership and borrowing guidance. |
| `P-E1` | SHOULD | Return `Result` for recoverable failures. Avoid `unwrap`, `expect`, and `panic!` for ordinary input and I/O failures. | Google permits panic and a reasoned `expect` for violated invariants. This project narrows their use because an AI agent should keep running when it can recover. |
| `P-A1` | SHOULD | Add only abstractions and dependencies needed for current requirements. Inspect callers before introducing general traits or `Into<T>` within application code. | Consistent with Google's preference for simple application code. |
| `P-X1` | REVIEW | Assess whether business logic separated from async I/O, failure paths, boundaries, and cancellation states can be tested. | Adds AI-agent testability criteria to Google's codebase-specific test guidance. |

## Codebase-specific rules not adopted

- Chromium's bans on async/await and starting threads through the Rust standard library apply to Chromium's execution model. They conflict with this project's Tokio-based asynchronous I/O requirements.
- Chromium's small-crate guidance, flat file layout, and `chromium::import!()` requirement reflect its build system. They do not justify changing a Cargo project's structure.
- Fuchsia's `fuchsia_sync::Mutex` requirement and test framework apply to Fuchsia, not a general Tokio-based Cargo project.

Do not ban `expect` outright. It may be justified when an invariant cannot be expressed in the type system and recovery cannot preserve correctness; include the reason. Judge `unwrap` and `expect` in tests by clarity and diagnostic value.
