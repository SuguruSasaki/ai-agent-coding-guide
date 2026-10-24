---
name: markdown-docs
description: >-
  Write or review repository Markdown documentation using Google's Markdown
  style guide. Apply to READMEs, guides, runbooks, and design notes, alongside
  a language skill when code also changes.
---

# Repository Markdown documentation

Use this skill when creating, changing, or reviewing repository Markdown. It
covers structure, navigation, source readability, code examples, links, and
content quality. For API comments or source code, use the relevant language
skill; use both skills when a task changes code and Markdown docs.

## Read context

Inspect the document's audience, purpose, renderer, nearby docs, actual
commands and file paths, and the exact diff. Read the
[Google Markdown summary](references/google-markdown-style.md) and
[host and project exceptions](references/project-exceptions.md). Consult
[examples](references/examples.md) when reviewing a concrete issue.

`MUST` is a clear, enforceable rule; `SHOULD` is the usual choice with valid
exceptions; `REVIEW` requires judgment about readers and content. These are
operational categories, not the source guide's labels or finding severity.
`G-M` identifies a summarized Google rule; `P-M` identifies a project policy
or host exception.

## Write and change

- Keep documentation small, accurate, and useful to the intended reader.
  Explain prerequisites and outcomes before lengthy commands. Check commands,
  filenames, links, and examples against the repository.
- Use one descriptive H1, a short introduction, logical headings, readable
  lists, labeled fenced code blocks, and meaningful links. Choose tables only
  for genuinely tabular comparisons.
- Keep edits focused. Do not reformat unrelated Markdown merely to satisfy a
  style preference. Adapt `[TOC]` and link paths to the actual renderer.
- Run existing Markdown lint or formatting checks when configured, plus
  `git diff --check`. Check changed local links and preview the changed
  document. Report checks that could not run as unverified. Tools do not
  establish that instructions are accurate or understandable.

## Review

Check reader tasks, factual accuracy, command copyability, link destinations,
heading navigation, image alt text, and source readability. Explain why a rule
helps the reader before proposing a change. Review-only requests do not
authorize edits. Order supported findings by impact:

```text
[Critical | Major | Minor] Short title
Location: path/to/file.md:line
Rule: [G-M...] or [P-M...] and rule name
Problem: Reader task, triggering condition, and impact.
Proposal: Concrete wording or structure; note renderer or compatibility tradeoffs.
Action: Automatable fix / Human judgment required
```

**Critical**: instructions likely to cause serious security, data loss, or
harmful operational action. **Major**: incorrect or unusable instructions for
an ordinary reader task. **Minor**: supported navigation, accessibility, or
readability improvement. Severity is separate from `MUST`/`SHOULD`/`REVIEW`.
Report checks run, results, unverified areas, and whether a problem is known
to predate the change; do not infer timing from one run. State explicitly when
there are no findings.

Codex may discover this skill from its description and `AGENTS.md`, or the
user may invoke `$markdown-docs` explicitly. It does not watch files
continuously.
