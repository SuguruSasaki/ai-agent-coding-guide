# AI Agent Coding Guide

Codex skills for generating, changing, and reviewing code and repository
Markdown. Each skill summarizes a primary style guide, distinguishes its rules
from project policy, and adds review beyond automated checks.

| Area | Skill | Primary guide | Validation |
| --- | --- | --- | --- |
| Rust | [`$rust-coding`](.agents/skills/rust-coding/SKILL.md) | [Google Rust Style Guide](https://google.github.io/styleguide/rustguide.html) | Cargo fmt, Clippy, tests |
| Swift | [`$swift-coding`](.agents/skills/swift-coding/SKILL.md) | [Google Swift Style Guide](https://google.github.io/swift/) and the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) it incorporates | SwiftPM build, tests, and available formatter lint |
| TypeScript | [`$typescript-coding`](.agents/skills/typescript-coding/SKILL.md) | [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) | Project typecheck, lint, and test scripts |
| Shell | [`$shell-coding`](.agents/skills/shell-coding/SKILL.md) | [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) | Syntax and ShellCheck; project tests separately |
| Repository Markdown | [`$markdown-docs`](.agents/skills/markdown-docs/SKILL.md) | [Google Markdown style guide](https://google.github.io/styleguide/docguide/style.html) | Project Markdown lint, links, rendered preview, and content review |

## Use in a project

Copy the full `.agents/skills/<skill-name>/` directory into the target
repository and merge the corresponding line from [AGENTS.md](AGENTS.md) into
that repository's agent instructions. Keep existing project rules and resolve
conflicts there. In Codex, invoke a skill with, for example,
`$markdown-docs Review this README` or `$typescript-coding Review this change`.
Automatic discovery depends on the Codex environment; verify it in a new
session in the target repository. Use the Markdown skill together with a
language skill when one change affects both documentation and code.

Run the validation script from the target project root, or pass the target
directory:

```bash
.agents/skills/rust-coding/scripts/validate.sh /path/to/cargo-project
.agents/skills/swift-coding/scripts/validate.sh /path/to/swift-package
.agents/skills/typescript-coding/scripts/validate.sh /path/to/typescript-project
.agents/skills/shell-coding/scripts/validate.sh /path/to/shell-project
```

The Swift script supports Swift Package Manager projects. For an Xcode-only
project, use its configured scheme and destination to run the equivalent build
and tests, then report those results separately. The TypeScript script uses
existing package scripts and a local compiler when available; it never
installs dependencies. The Shell script checks Bash/POSIX shell syntax and runs
ShellCheck when installed; run any project-specific tests separately and report
missing tools as unverified. The Rust formatter settings in
[`rustfmt.toml`](rustfmt.toml) are an optional template; compare them with the
target project's configuration before adopting them. For Markdown, use the
target project's existing Markdown lint, check changed links and rendered
output, and review the content for accuracy.

This repository contains agent instructions and examples, not an application.
Validation on a target project cannot establish whether a failure was
pre-existing without an unchanged baseline. Code skills require design review
for API intent, error handling, concurrency, and testability. The Markdown
skill reviews navigation, accuracy, and readability in the rendered document.
