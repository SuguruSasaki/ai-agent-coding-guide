# Google Swift Style Guide: working summary

Primary source: [Google Swift Style Guide](https://google.github.io/swift/). Its [Naming section](https://google.github.io/swift/#naming) incorporates the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) as part of the guide. This summary is selective; consult the source for exceptions and detailed line wrapping.

`MUST`, `SHOULD`, and `REVIEW` are this skill's operational categories, not the source document's own labels or finding severity.

| ID | Level | Area | Working rule and rationale |
| --- | --- | --- | --- |
| G-S01 | MUST | Source basics | Use `.swift` files encoded as UTF-8, with spaces instead of tab indentation. This keeps source display consistent. [Source](https://google.github.io/swift/#source-file-basics) |
| G-S02 | SHOULD | Imports | Import each top-level module directly when its definitions are used; prefer whole modules and group imports as prescribed. Do not rely on a transitive import. [Source](https://google.github.io/swift/#import-statements) |
| G-S03 | MUST | Formatting | Follow the 100-column limit, K&R-style braces, and no semicolons, subject to the guide's explicit exceptions for long units, imports, generated code, and certain single-line blocks. [Source](https://google.github.io/swift/#general-formatting) |
| G-S04 | SHOULD | Formatting | Use the guide's line wrapping and whitespace conventions, including two-space continuation indentation where specified. Match a target project's established formatter configuration when it conflicts and record the choice. [Source](https://google.github.io/swift/#line-wrapping) |
| G-S05 | REVIEW | Naming and API | Make names and argument labels clear at the call site. Prefer clarity over brevity; omit needless words and use the type system to express meaning. Inspect actual usage rather than judging only the declaration. [Source](https://www.swift.org/documentation/api-design-guidelines/#fundamentals) |
| G-S06 | SHOULD | Access and structure | Use access control to hide implementation details; use logical member ordering and nested types where they clarify a relationship. Naming prefixes are not access control. [Source](https://google.github.io/swift/#naming-conventions-are-not-access-control) |
| G-S07 | REVIEW | Optional and error design | Use `Optional` for expected absence or a single obvious failure state; use an error type and `throws` when callers need to distinguish multiple failures. Avoid magic sentinel values. Judge what callers actually need to handle. [Source](https://google.github.io/swift/#optional-types) |
| G-S08 | SHOULD | Failure safety | Avoid force unwraps, force casts, and implicitly unwrapped optionals unless an invariant or lifecycle requirement justifies them. If safety is not obvious, explain the invariant; tests and specific UI lifecycle cases have exceptions. [Source](https://google.github.io/swift/#force-unwrapping-and-force-casts) |
| G-S09 | REVIEW | Control flow | Use `guard` when it exposes an exceptional early exit and leaves the main path clear; do not replace every `if` mechanically. [Source](https://google.github.io/swift/#guards-for-early-exits) |
| G-S10 | SHOULD | Documentation | Document every `open`/`public` declaration and member unless a listed exception applies. Give a useful summary and explain parameter, return, and error semantics when the signature and summary do not. [Source](https://google.github.io/swift/#where-to-document) |
| G-S11 | SHOULD | Compiler feedback | Resolve compiler warnings that the author can reasonably fix. Some deprecation warnings may remain temporarily with a reason. [Source](https://google.github.io/swift/#compiler-warnings) |
| G-S12 | REVIEW | Types | Prefer types and signatures that reveal valid states and make behavior understandable to clients. Review whether a nested error type or an `enum` makes a domain distinction clear. [Source](https://google.github.io/swift/#programming-practices) |

The Google guide's published text does not define rules for `async`/`await`, actors, `Sendable`, or task cancellation. See [project policy](project-exceptions.md) for those topics. A formatter can flag syntax and layout, but cannot decide if an `Optional` hides useful errors, an API label misleads callers, or actor state crosses a suspension safely.
