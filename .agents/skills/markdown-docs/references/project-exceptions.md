# Renderer and project exceptions

These decisions adapt the Google Markdown guide to GitHub-hosted agent guides
and to the target project's actual renderer. They are not Google rules.

| ID | Level | Decision and reason |
| --- | --- | --- |
| P-M01 | MUST | Check the target renderer before adding syntax such as `[TOC]`. GitHub automatically builds an outline from headings; do not insert a literal Gitiles `[TOC]` directive into GitHub README files. |
| P-M02 | SHOULD | For GitHub repository docs, prefer working relative links to other repository files, including cross-directory links when needed. GitHub resolves them by branch and they also work in local clones. This deliberately relaxes Google's preference to avoid `../` outside one directory. |
| P-M03 | REVIEW | Apply the 80-character source convention with its stated exceptions and readability judgment. Do not split a useful URL, table cell, command, or non-English phrase merely to meet a mechanical count. |
| P-M04 | SHOULD | In `SKILL.md`, keep the required YAML frontmatter and a meaningful reader-facing H1 even though the fixed filename cannot describe the skill's subject. Do not rename the file to make the title match it. |
| P-M05 | REVIEW | Verify examples and commands against the repository and target toolchain. Do not claim an example was executed when it was only read or syntax-checked. Preserve existing project-specific terminology and instructions. |

Sources for host differences:
[Google TOC and link guidance](https://google.github.io/styleguide/docguide/style.html#table-of-contents)
and [GitHub README rendering and relative links](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes).
For another renderer, use its documented behavior rather than carrying GitHub
exceptions over automatically.
