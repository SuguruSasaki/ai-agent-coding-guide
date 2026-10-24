---
name: shell-coding
description: >-
  Apply the Google Shell Style Guide when writing, changing, or reviewing
  Bash scripts. Review quoting, arguments, errors, portability, and whether
  shell remains the right tool beyond syntax and ShellCheck.
---

# Shell coding and review

Use this skill for executable Bash scripts and Bash libraries. Confirm the
target interpreter before applying Bash-specific syntax to a POSIX `sh`, Zsh,
or other script. For Markdown containing shell examples, also use
`$markdown-docs`.

## Read context

Inspect `AGENTS.md`, the interpreter and supported platforms, callers,
inputs, side effects, tests, and the diff. Read the relevant entries in the
[Google rule summary](references/google-shell-style.md) and
[project policy and exceptions](references/project-exceptions.md). Use the
[examples](references/examples.md) to check review judgments.

`MUST` means a clear rule that can be enforced; `SHOULD` permits a justified
exception; `REVIEW` requires context. These are operational labels, not the
source guide's severity levels. `G-S` identifies a summarized Google rule and
`P-S` identifies local policy.

## Generate and change

- Prefer shell for short orchestration. If parsing, state, or control flow is
  becoming hard to verify, consider a more structured language. Preserve the
  target project's interpreter and dependencies.
- Trace each argument from input through expansion to command invocation.
  Use arrays for argument lists, quote expansions, avoid `eval`, and inspect
  filenames beginning with `-` or containing whitespace and newlines.
- Check each important command's failure path, including pipelines and command
  substitutions. Keep expected output on stdout and diagnostics on stderr.
- Keep the edit focused. Follow established style in existing files where
  Google allows it; do not add dependencies or unrelated rewrites.
- Run `scripts/validate.sh` on the target script or project after editing.
  Run relevant project tests or safe fixture-based behavior checks separately.
  Syntax and ShellCheck cannot establish behavior or safety. Compare failures
  with an unchanged baseline before attributing them to this change.

## Review

Reproduce or reason through concrete inputs: empty values, paths with spaces,
leading dashes, command failures, pipeline stages, and repeated runs. Check
whether the script uses shell appropriately and whether its cleanup and
failure behavior match callers' expectations. Do not edit for a review-only
request. Report supported findings in impact order:

```text
[Critical | Major | Minor] Short title
Location: path/to/script.sh:line
Rule: [G-S...] or [P-S...] and rule name
Problem: Triggering input or failure and its impact.
Proposal: Concrete change and any compatibility tradeoff.
Action: Automatable fix / Human judgment required
```

**Critical** means a plausible security, destructive, or data-loss path.
**Major** means incorrect normal behavior or an unhandled important failure.
**Minor** means a supported readability or maintainability issue. Severity is
independent of `MUST`/`SHOULD`/`REVIEW`. End with checks run, failures,
unverified checks, and baseline evidence if available; say when no findings
remain. Codex may discover this skill or invoke it explicitly as
`$shell-coding`; it does not watch files continuously.
