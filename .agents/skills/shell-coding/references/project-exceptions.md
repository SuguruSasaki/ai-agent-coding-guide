# Shell agent project policy and exceptions

These are local decisions, not Google rules. Check the target project's
interpreter and platform support before applying them.

| ID | Level | Decision and reason |
| --- | --- | --- |
| P-S01 | SHOULD | Use `#!/usr/bin/env bash` when `/bin/bash` is not a dependable deployment path, as in this repository's existing scripts. Google specifies `#!/bin/bash`; retaining the established shebang lets a project's selected Bash be used. If an environment requires an absolute interpreter path, use that path. |
| P-S02 | MUST | For scripts intended to run on macOS's bundled Bash, avoid Bash 4+ features such as `readarray` and associative arrays. Google recommends `readarray` only for Bash 4+; process substitution or a simple loop can cover supported cases. Explicitly document a Bash 4+ minimum when required instead. |
| P-S03 | REVIEW | Do not add `set -e` as a reflex or ban it categorically. Choose explicit status checks or strict mode based on the script's callers and failure semantics; test conditionals, pipelines, arithmetic, and cleanup under those options. |
| P-S04 | SHOULD | Validate existing POSIX `sh` scripts with their intended interpreter. Do not insert Bash `[[ ... ]]` or arrays into them merely to satisfy Bash guidance. Google itself allows another shell when the environment requires one. |
| P-S05 | REVIEW | For scripts touching user files, remote services, credentials, or deployment state, review dry-run options, target paths, permissions, cleanup, and repeatability according to actual risk. Avoid adding a shell abstraction or a dependency for hypothetical needs. |
| P-S06 | MUST | Report syntax, ShellCheck, and project tests separately. Missing ShellCheck or tests are `NOT RUN`, never a pass. A current failure is not evidence it was introduced by the latest change without a baseline comparison. |

The [Google interpreter rule](https://google.github.io/styleguide/shellguide.html#which-shell-to-use)
and [Bash 4+ note](https://google.github.io/styleguide/shellguide.html#pipes-to-while)
are the source of the two explicit compatibility decisions above.
