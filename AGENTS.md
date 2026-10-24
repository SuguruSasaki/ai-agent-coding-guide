# Development instructions for AI agent coding guides

Use the language skill for implementation, changes, and reviews:

- Rust: [rust-coding](.agents/skills/rust-coding/SKILL.md), explicitly `$rust-coding` in Codex.
- Swift: [swift-coding](.agents/skills/swift-coding/SKILL.md), explicitly `$swift-coding` in Codex.
- TypeScript: [typescript-coding](.agents/skills/typescript-coding/SKILL.md), explicitly `$typescript-coding` in Codex.
- Shell: [shell-coding](.agents/skills/shell-coding/SKILL.md), explicitly
  `$shell-coding` in Codex.
- Repository Markdown: [markdown-docs](.agents/skills/markdown-docs/SKILL.md),
  explicitly `$markdown-docs` in Codex. Apply it alongside the relevant
  language skill when a task changes both code and Markdown documentation.

Before editing, inspect the existing design, callers, and build configuration.
After editing code, run its language skill's validation script against the
target project and review design decisions that automated tools cannot judge.
For Markdown, follow the checks in its skill. For review-only requests, do not
change code or documentation. Report unrun checks as unverified. In a
mixed-language change, apply each relevant language skill only to its language.
