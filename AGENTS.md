# Development instructions for AI agent coding guides

Use the language skill for implementation, changes, and reviews:

- Rust: [rust-coding](.agents/skills/rust-coding/SKILL.md), explicitly `$rust-coding` in Codex.
- Swift: [swift-coding](.agents/skills/swift-coding/SKILL.md), explicitly `$swift-coding` in Codex.

Before editing, inspect the existing design, callers, and build configuration. After editing, run the relevant skill's validation script against the target project and review design decisions that automated tools cannot judge. For review-only requests, do not change code. Report unrun checks as unverified. In a mixed-language change, apply each relevant skill only to its language.
