# Google Markdown style guide: working summary

Primary source:
[Google Markdown style guide](https://google.github.io/styleguide/docguide/style.html).
It covers Markdown source and rendered documents, not general prose or code.
This is a selective summary; consult the source for examples and exceptions.

`MUST`, `SHOULD`, and `REVIEW` are operational categories for this skill,
not source quotations or finding severity.

| ID | Level | Area | Working rule and reason |
| --- | --- | --- | --- |
| G-M01 | REVIEW | Scope and review | Maintain a small set of fresh, accurate docs. A useful improvement need not perfect unrelated pages; give actionable review suggestions. [Source](https://google.github.io/styleguide/docguide/style.html#minimum-viable-documentation) [Review](https://google.github.io/styleguide/docguide/style.html#better-is-better-than-best) |
| G-M02 | SHOULD | Layout | Start with one H1 and a short introduction for newcomers; continue with H2 or deeper headings. Add a `See also` section when useful. [Source](https://google.github.io/styleguide/docguide/style.html#document-layout) |
| G-M03 | SHOULD | Table of contents | Place a `[TOC]` directive after the introduction only when the hosting renderer supports it and the page merits one. The source guide assumes Gitiles-like support. [Source](https://google.github.io/styleguide/docguide/style.html#table-of-contents) |
| G-M04 | SHOULD | Source width | Wrap prose near 80 characters. Links, tables, headings, and code blocks are explicit exceptions; preserve readable units rather than splitting them mechanically. [Source](https://google.github.io/styleguide/docguide/style.html#character-line-limit) |
| G-M05 | MUST | Whitespace and headings | Avoid trailing whitespace. Use ATX (`#`) headings with spacing, one H1, and unique, descriptive heading names so source and anchors remain clear. [Source](https://google.github.io/styleguide/docguide/style.html#trailing-whitespace) [Headings](https://google.github.io/styleguide/docguide/style.html#headings) |
| G-M06 | SHOULD | Lists | Keep list indentation consistent, especially four-space continuation and nesting. Simple short lists may use one space after a marker. Use lazy numbering for long lists likely to change. [Source](https://google.github.io/styleguide/docguide/style.html#lists) |
| G-M07 | SHOULD | Code | Use code spans for literal names and fenced blocks for multiline code, with a language label when possible. Make shell snippets copyable; escape intended line continuations. [Source](https://google.github.io/styleguide/docguide/style.html#code) |
| G-M08 | SHOULD | Links | Give links informative text; use explicit destinations and reference links when long URLs or repetition would make source hard to read. The guide prefers avoiding `../` paths outside one directory. [Source](https://google.github.io/styleguide/docguide/style.html#links) |
| G-M09 | SHOULD | Images | Use images only when they make a task easier to understand, and provide descriptive alternative text for readers who cannot see them. [Source](https://google.github.io/styleguide/docguide/style.html#images) |
| G-M10 | REVIEW | Tables | Use tables for compact, genuinely two-dimensional data; use lists or headings when cells become long, sparse, or uneven. [Source](https://google.github.io/styleguide/docguide/style.html#tables) |
| G-M11 | SHOULD | Portability | Prefer standard Markdown to HTML workarounds so source remains readable and portable. Preserve product and tool capitalization. [Source](https://google.github.io/styleguide/docguide/style.html#strongly-prefer-markdown-to-html) [Names](https://google.github.io/styleguide/docguide/style.html#capitalization) |

Mechanical checks can find whitespace and some structural issues. Only a
reader-oriented review can establish whether steps are accurate, a link label
is informative, a table helps scanning, or an image clarifies the task.
