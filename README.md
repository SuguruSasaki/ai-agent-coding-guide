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

Choose skills for files the agent will maintain in that product. Add a language
skill for each planned source language, the Markdown skill if agents will edit
repository docs, and the Shell skill if they will edit shell scripts. If the
stack is undecided, wait until the project takes shape. In the target project's
directory, run this command with Node.js, npm, Git, and Bash available:

```bash
npx -y -p github:SuguruSasaki/ai-agent-coding-guide \
  ai-agent-coding-guide typescript markdown
```

The available names are `rust`, `swift`, `typescript`, `shell`, and `markdown`.
To use a local checkout, replace the GitHub package specifier with this
repository's absolute path:

```bash
npx -y -p /path/to/ai-agent-coding-guide \
  ai-agent-coding-guide typescript markdown
```

The command copies only the selected skills into `.agents/skills/`, adds
`./.agents/validate`, and adds a short instruction block to the project's root
`AGENTS.md`, creating that file if needed. Existing project instructions stay
in place. When the project adds another language, run the command again with
its name, for example:

```bash
npx -y -p github:SuguruSasaki/ai-agent-coding-guide \
  ai-agent-coding-guide rust
```

Repeated runs do not duplicate the instruction block or identical skill files.
The installer stops if an existing skill or validation command differs; inspect
and reconcile it before retrying. Review the resulting diff, especially any
instructions that conflict with the project's own rules. Commit `AGENTS.md`
and `.agents/` in the target project if the team should use the guide.
Keep product-specific architecture, build commands, and conventions in that
project's `AGENTS.md`; the copied skills provide language guidance.

Start a new Codex session in the project and invoke a skill explicitly, for
example, `$typescript-coding Review this change`. Automatic skill discovery
depends on the Codex environment, so verify it in the target project. Use
`$markdown-docs` together with a language skill when a change affects both
documentation and code.

For a manual installation, copy a complete `.agents/skills/<skill-name>/`
directory and add the matching instructions from [AGENTS.md](AGENTS.md) to the
target project's `AGENTS.md`.

## Validate a project

From the project root, use the installed command. If only one code validator
is installed, it selects that validator automatically:

```bash
./.agents/validate
```

With multiple code validators, name the language. Pass a target path when the
project lives in a subdirectory, or when checking one Shell script:

```bash
./.agents/validate typescript
./.agents/validate rust packages/core
./.agents/validate shell scripts/build.sh
```

The command returns the selected skill's validation result. The Markdown skill
has no script; follow its lint, link, preview, and content checks.

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
