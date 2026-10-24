# AI Agent Coding Guide

Language-specific Codex skills for generating, changing, and reviewing code. Each skill summarizes a primary style guide, distinguishes its rules from project policy, and adds design review beyond automated formatting and linting.

| Language | Skill | Primary guide | Validation |
| --- | --- | --- | --- |
| Rust | [`$rust-coding`](.agents/skills/rust-coding/SKILL.md) | [Google Rust Style Guide](https://google.github.io/styleguide/rustguide.html) | Cargo fmt, Clippy, tests |
| Swift | [`$swift-coding`](.agents/skills/swift-coding/SKILL.md) | [Google Swift Style Guide](https://google.github.io/swift/) and the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) it incorporates | SwiftPM build, tests, and available formatter lint |

## Use in a project

Copy the full `.agents/skills/<language>/` directory into the target repository and merge the corresponding line from [AGENTS.md](AGENTS.md) into that repository's agent instructions. Keep existing project rules and resolve conflicts there. In Codex, invoke a skill with, for example, `$swift-coding Review this change` or `$rust-coding Implement this API`. Automatic discovery depends on the Codex environment; verify it in a new session in the target repository.

Run the validation script from the target project root, or pass the target directory:

```bash
.agents/skills/rust-coding/scripts/validate.sh /path/to/cargo-project
.agents/skills/swift-coding/scripts/validate.sh /path/to/swift-package
```

The Swift script supports Swift Package Manager projects. For an Xcode-only project, use its configured scheme and destination to run the equivalent build and tests, then report those results separately. The Rust formatter settings in [`rustfmt.toml`](rustfmt.toml) are an optional template; compare them with the target project's configuration before adopting them.

This repository contains agent instructions and examples, not a Rust or Swift application. Validation on a target project cannot establish whether a failure was pre-existing without an unchanged baseline. Both skills require a separate design review for API intent, error handling, concurrency, and testability.
