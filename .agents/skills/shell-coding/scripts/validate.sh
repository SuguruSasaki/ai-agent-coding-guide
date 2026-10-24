#!/usr/bin/env bash
# Check shell syntax and run ShellCheck without changing target files.
set -u
set -o pipefail

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  cat <<'USAGE'
Usage: validate.sh [script-or-project-directory]

Check Bash and POSIX sh files in a target directory, or one script. The
default is the current directory. In directory mode, find .sh/.bash files
and extensionless files with a Bash or sh shebang, excluding common build
and dependency directories, including .agents. Project behavior tests must be
run separately.
Exit 1 for a failed check, 2 when a check is unavailable or no files match.
USAGE
  exit 0
fi
if (( $# > 1 )); then
  printf 'Usage: validate.sh [script-or-project-directory]\n' >&2
  exit 2
fi

target=${1:-$PWD}
if [[ ! -f $target && ! -d $target ]]; then
  printf 'NOT RUN: target does not exist: %s\n' "$target" >&2
  exit 2
fi

files=()
if [[ -f $target ]]; then
  files+=("$target")
else
  paths_file=$(mktemp) || exit 2
  trap 'rm -f "$paths_file"' EXIT
  if ! find "$target/." \( -name .git -o -name .agents -o -name node_modules \
      -o -name .build \
      -o -name target -o -name dist \) -prune -o -type f -print0 > "$paths_file"; then
    printf 'NOT RUN: failed to list target files\n' >&2
    exit 2
  fi
  while IFS= read -r -d '' candidate; do
    first_line=$(head -n 1 "$candidate")
    case $candidate in
      *.sh|*.bash) files+=("$candidate") ;;
      *)
        if [[ $first_line =~ ^#!.*[/[:space:]](bash|sh)([[:space:]]|$) ]]; then
          files+=("$candidate")
        fi
        ;;
    esac
  done < "$paths_file"
fi

if (( ${#files[@]} == 0 )); then
  printf 'NOT RUN: no Bash or POSIX sh files found in %s\n' "$target" >&2
  exit 2
fi

printf 'Target: %s\nFiles: %s\n' "$target" "${#files[@]}"
printf 'Project behavior tests: NOT RUN (run the target project tests separately).\n'
printf 'Compare failures with an unchanged baseline before attributing them to this change.\n'
syntax_failed=0
lint_failed=0
unverified=0
skipped=0
if command -v shellcheck >/dev/null 2>&1; then
  lint_available=1
else
  lint_available=0
  unverified=1
  printf 'ShellCheck: NOT RUN (shellcheck is unavailable).\n' >&2
fi

for file in "${files[@]}"; do
  first_line=$(head -n 1 "$file")
  mode=bash
  if [[ $first_line == '#!'* ]]; then
    if [[ $first_line =~ [/[:space:]]bash([[:space:]]|$) ]]; then
      mode=bash
    elif [[ $first_line =~ [/[:space:]]sh([[:space:]]|$) ]]; then
      mode=sh
    else
      printf 'NOT RUN: unsupported interpreter in %s\n' "$file" >&2
      unverified=1
      skipped=1
      continue
    fi
  fi
  printf '\n[%s syntax] %s\n' "$mode" "$file"
  if "$mode" -n "$file"; then
    printf 'PASS: syntax\n'
  else
    printf 'FAIL: syntax\n' >&2
    syntax_failed=1
  fi
  if (( lint_available )); then
    printf '[ShellCheck] %s\n' "$file"
    if shellcheck -s "$mode" -- "$file"; then
      printf 'PASS: ShellCheck\n'
    else
      printf 'FAIL: ShellCheck\n' >&2
      lint_failed=1
    fi
  fi
done

syntax_status=PASS
lint_status=PASS
if (( skipped )); then syntax_status='NOT RUN/incomplete'; fi
if (( syntax_failed )); then syntax_status=FAIL; fi
if (( unverified )); then lint_status='NOT RUN/incomplete'; fi
if (( lint_failed )); then lint_status=FAIL; fi
printf '\nResults: syntax=%s ShellCheck=%s project-tests=NOT RUN\n' \
  "$syntax_status" "$lint_status"
if (( syntax_failed || lint_failed )); then
  exit 1
fi
if (( unverified )); then
  exit 2
fi
exit 0
