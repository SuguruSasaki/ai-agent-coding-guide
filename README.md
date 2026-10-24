# Rust coding skill for AI agents

This repository helps an agent assess design quality when generating, changing, or reviewing Rust code. It applies the goals and exceptions of the Google Rust Style Guide. The agent starts with [SKILL.md](.agents/skills/rust-coding/SKILL.md). Detailed rules live in `references/`, and [project exceptions](.agents/skills/rust-coding/references/project-exceptions.md) cover choices such as Tokio-based async/await.

## Installation and use

Copy the entire `.agents/skills/rust-coding/` directory into a Cargo project and merge this repository's `AGENTS.md` guidance into the project's root `AGENTS.md`. Preserve existing project instructions. If useful, compare the 100-column setting in `rustfmt.toml` with the project's current formatter configuration before adopting it.

To invoke the skill explicitly in Codex, use a prompt such as `$rust-coding Review this Rust change`. The skill does not watch files continuously. Check skill discovery and loading in a new Codex session in the target project.

## Validation

Run `.agents/skills/rust-coding/scripts/validate.sh` from the Cargo project root. From another directory, pass the Cargo project directory as an argument. The script runs formatting, Clippy, and tests, and reports each result. To distinguish existing failures from failures introduced by a change, compare with the unchanged baseline under the same conditions.

This repository has no `Cargo.toml` or Rust application code. The primary source for the rules is the [Google Rust Style Guide](https://google.github.io/styleguide/rustguide.html).
