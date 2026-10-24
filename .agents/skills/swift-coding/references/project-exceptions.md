# Swift agent project policy and exceptions

These rules supplement Google Swift style for an AI agent implementation. They are not Google requirements. Where an existing target project has a deliberate, documented convention, inspect it before proposing a change.

| ID | Level | Policy and reason |
| --- | --- | --- |
| P-S01 | SHOULD | Use Swift `async`/`await` for asynchronous I/O when supported by the target platform. Keep transport and tool I/O separate from deterministic domain decisions so logic can be tested without network services. |
| P-S02 | REVIEW | Choose actor isolation or another explicit synchronization boundary for shared mutable state. Check state again after an `await` when reentrancy can change an invariant. Respect `Sendable` and isolation diagnostics for the configured Swift language mode. |
| P-S03 | REVIEW | Give child tasks an owned lifecycle. Propagate cancellation to long-running model, tool, and network work and clean up resources. Use detached tasks only when their independent lifetime is intentional and documented. |
| P-S04 | SHOULD | Model recoverable failures with `throws` and meaningful error information. Do not hide a network or tool error with `try?`, `try!`, `fatalError`, or a forced unwrap unless the failure is genuinely irrelevant or an invariant is proven. |
| P-S05 | SHOULD | Prefer the simplest concrete API that fits current callers. Introduce protocols, type erasure, dependencies, and reference sharing only for a demonstrated need. Favor injectable boundaries for external effects. |
| P-S06 | REVIEW | Test ordinary behavior, error paths, cancellation or isolation where relevant, and a public API at its call site. Use fakes or controlled dependencies for external effects; do not add tests that merely repeat implementation details. |

## Relationship to the Google guide

- The published Google Swift guide is silent on modern Swift Concurrency; `P-S01` through `P-S03` extend it. They are **not** exceptions to a Google async prohibition. A Chromium-specific async restriction mentioned in the Rust context does not apply to Swift.
- `P-S04` is stricter about recoverable agent I/O failures than the Google guide's narrow, documented allowances for force operations in tests or proven invariants. Those allowances remain valid where the condition is genuinely established.
- The Google guide describes style, naming, and core language practices; it does not specify this project's architecture, dependency budget, or test strategy. `P-S05` and `P-S06` are local design criteria.
