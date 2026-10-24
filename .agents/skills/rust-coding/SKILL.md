---
name: rust-coding
description: Apply the Google Rust Style Guide when implementing or reviewing a Rust AI agent. Review API design, ownership, errors, Tokio concurrency, and exceptions that automated linting cannot judge.
---

# Rust coding and review

Use the Google Rust Style Guide as a source of design principles. Judge code against its actual requirements, callers, and costs. A rule's presence alone does not establish a defect. Use this skill for Rust implementation, changes, and reviews. Apply Rust rules to documentation-only work only when the documentation describes Rust behavior.

## Read the relevant context

1. Inspect the project's `AGENTS.md`, `Cargo.toml`, toolchain, existing code, and tests. For a change, identify the exact diff and inspect callers and surrounding implementation.
2. Read both [Google rule summary](references/google-rust-style.md) and [project exceptions](references/project-exceptions.md) for implementation and review work.
3. Consult [examples](references/examples.md) when assessing a design choice or preparing a review finding.

Keep Google rules separate from project policy. `MUST` means a rule that can be enforced clearly; `SHOULD` is the usual recommendation with valid exceptions; `REVIEW` requires judgment from requirements and surrounding code. These are this skill's operational categories. They do not describe the force of the original Google text or the severity of a finding.

## Generate and change code

- Inspect requirements, existing public APIs, and callers before implementing. Apply the purpose and exceptions of relevant rules.
- Keep changes within the requested scope. Do not add broad refactors, abstractions, or dependencies solely to satisfy a style preference.
- Run `scripts/validate.sh` against the target Cargo workspace after editing. Follow or add project-specific checks where applicable. Report failed and unrun checks.
- Review changed APIs, ownership, errors, async behavior, and testability in addition to automated results. Rerun affected checks after fixing a finding.

## Review code

Read the requirements, callers, error paths, state transitions, and tests as well as the diff. For each candidate finding, establish the triggering condition, impact, rule purpose, exceptions, and cost of a proposed change. Report a supported design improvement, but distinguish it from a bug. Do not edit code for a review-only request.

Order findings by impact. Use this format:

```text
[Critical | Major | Minor] Short title
Location: path/to/file.rs:line
Rule: [G-...] or [P-...] and the rule name
Problem: Triggering condition and impact; label uncertainty as a question to verify.
Proposal: Improvement and relevant compatibility or cost tradeoffs.
Action: Automatable fix / Human judgment required
```

- **Critical**: A serious security, safety, authentication, or data-integrity defect.
- **Major**: Incorrect behavior in ordinary use, an unrecoverable failure, or a significant API-contract violation.
- **Minor**: A supported design or maintainability improvement, or a limited defect. Do not report taste alone.

Severity is independent of `MUST`, `SHOULD`, and `REVIEW`. A formatting issue fixable by `cargo fmt` is automatable; changing ownership or a public API normally needs human judgment. If there are no findings, say so. End with checks run, their results, unverified areas, and any distinction supported by evidence between pre-existing problems and problems introduced by the change. Do not infer when a failure began from a single validation run.

This skill does not continuously watch files. Codex selects it through the skill description and `AGENTS.md` instructions, or the user can invoke it explicitly with `$rust-coding`.
