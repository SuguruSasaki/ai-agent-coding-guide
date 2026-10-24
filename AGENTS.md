# Development instructions for the Rust AI agent

For Rust code generation, changes, and reviews, read the [rust-coding skill](.agents/skills/rust-coding/SKILL.md) and apply the relevant rules and project exceptions. In Codex, invoke it explicitly with `$rust-coding`.

Before editing, inspect the existing design, callers, and Cargo configuration. After editing, run the skill's `scripts/validate.sh` against the target Cargo project and perform a design review in addition to automated checks. For review-only requests, do not change code. Report checks that could not be run as unverified.
