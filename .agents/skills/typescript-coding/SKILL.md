---
name: typescript-coding
description: Apply the Google TypeScript Style Guide when implementing or reviewing TypeScript or TSX. Review API types, runtime boundaries, errors, async behavior, and testability beyond linting.
---

# TypeScript coding and review

Use this skill for TypeScript and TSX implementation, changes, and reviews. Apply the Google guide's purpose to actual requirements and callers. The public guide is adapted from Google's internal guide and warns that some rules may not fit external environments. Do not assume a formatter or compiler can judge design quality.

## Read the relevant context

1. Inspect the project's `AGENTS.md`, `package.json`, package manager, `tsconfig` files, lint/format settings, code, and tests. For changes, inspect the diff and callers.
2. Read the [Google rule summary](references/google-typescript-style.md) for relevant topics and [project policy and exceptions](references/project-exceptions.md) before implementation or review.
3. Consult [examples](references/examples.md) when reviewing an API, unsafe assertion, or async boundary.

`MUST` is clearly enforceable, `SHOULD` is the usual choice with justified exceptions, and `REVIEW` needs contextual evidence. These are this skill's operational categories, not the Google guide's RFC 2119 language or finding severity. IDs `G-T` summarize Google; IDs `P-T` are project policy.

## Generate and change code

- Check how exported APIs read at call sites. Treat JSON, tool results, and model output as untrusted until validated at runtime; TypeScript types disappear at runtime.
- Keep edits in scope. Follow established toolchain and framework conventions where the documented exceptions apply; avoid unrelated reformatting and dependencies.
- Run `scripts/validate.sh` against the target package after editing, plus project-specific checks where needed. The script does not install dependencies or prove Google-style conformance. Report failed and unrun checks, then review API clarity, data validation, async lifetimes, errors, and tests.

## Review

Inspect requirements, call sites, error paths, external inputs, promise lifetimes, and tests. For each candidate issue, establish the trigger, impact, rule purpose, and exception before reporting it. Do not edit code for a review-only request. Use this format, ordered by impact:

```text
[Critical | Major | Minor] Short title
Location: path/to/file.ts:line
Rule: [G-T...] or [P-T...] and rule name
Problem: Triggering condition and impact; mark uncertainty as a question to verify.
Proposal: Concrete change and compatibility or cost tradeoffs.
Action: Automatable fix / Human judgment required
```

**Critical** means serious security, safety, authentication, or data-integrity harm. **Major** means incorrect ordinary behavior, an unrecoverable failure, or a significant API-contract issue. **Minor** means a supported design or maintainability improvement or limited defect, not taste alone. Severity is independent of `MUST`/`SHOULD`/`REVIEW`. Formatting is often automatable; public API and boundary design usually require human judgment. End with checks run, results, unverified areas, and baseline evidence if available. Say explicitly when there are no findings.

The skill does not continuously monitor files. Codex may select it from its description and `AGENTS.md`, or the user can invoke `$typescript-coding` explicitly.
