---
name: swift-coding
description: Apply the Google Swift Style Guide when implementing or reviewing Swift code. Review API clarity, optionals, errors, Swift concurrency, documentation, and testability beyond formatter checks.
---

# Swift coding and review

Use this skill for Swift implementation, changes, and reviews. Apply the Google guide's intent to the actual requirements and call sites; a rule alone does not prove a defect. The guide incorporates Apple's Swift API Design Guidelines. Modern concurrency guidance here is project policy, not a Google rule.

## Context and rules

1. Inspect the project's `AGENTS.md`, `Package.swift` or Xcode build settings, Swift version, existing code, and tests. For changes, inspect the diff, callers, and surrounding behavior.
2. Read the [Google rule summary](references/google-swift-style.md) for relevant topics and the [project policy and exceptions](references/project-exceptions.md) before implementation or review.
3. Consult the [review examples](references/examples.md) when assessing an API or concurrency decision.

`MUST` is a clearly enforceable instruction, `SHOULD` is the usual choice with justified exceptions, and `REVIEW` needs evidence from context. These are operational categories for this skill, not quotations of the Google guide or finding severity. Rule IDs beginning `G-S` summarize Google (including its adopted Swift API guidelines); `P-S` marks project policy.

## Implement and change

- Design for clear usage at call sites. Check optional/error meaning, access level, documentation, and, when applicable, actor isolation and cancellation.
- Keep edits within scope; avoid broad refactors or new dependencies for style alone.
- Run `scripts/validate.sh` on a SwiftPM target after changes. For Xcode-only targets, run project-specific build, tests, and formatting checks. Report every failed or unrun check.
- Review design beyond tool output; rerun affected checks after fixes. Distinguish existing failures from introduced failures only with baseline evidence.

## Review

Examine requirements, call sites, error paths, state changes, task lifecycle, and tests. For each potential issue, explain the triggering condition, impact, rule purpose, and any justified exception. Do not edit code for a review-only request. Report supported improvements, not taste alone.

Order findings by impact and use this format:

```text
[Critical | Major | Minor] Short title
Location: path/to/file.swift:line
Rule: [G-S...] or [P-S...] and rule name
Problem: Triggering condition and impact; mark uncertainty as a question to verify.
Proposal: Concrete change and relevant compatibility or cost tradeoffs.
Action: Automatable fix / Human judgment required
```

**Critical**: serious security, safety, authentication, or data-integrity defect. **Major**: incorrect ordinary behavior, unrecoverable failure, or significant API-contract issue. **Minor**: supported design or maintainability improvement, or limited defect. Severity is independent of `MUST`, `SHOULD`, and `REVIEW`. Formatting is often automatable; public API and concurrency design usually require human judgment. End with checks run, results, unverified areas, and baseline evidence where available. State explicitly when there are no findings.

The skill does not monitor files continuously. Codex may select it from its description and `AGENTS.md`, or the user can invoke `$swift-coding` explicitly.
