#!/usr/bin/env bash
# Validate a Swift Package Manager project without modifying source files.
set -u
set -o pipefail

usage() {
  cat <<'USAGE'
Usage: validate.sh [project-directory]

Run swift build, swift test, and swift format lint on Sources and Tests when
swift-format is available. The target must have Package.swift. The default
directory is the current working directory. This script does not handle
Xcode-only projects; use their configured scheme and destination instead.
USAGE
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  usage
  exit 0
fi
if (( $# > 1 )); then
  usage >&2
  exit 2
fi

project_dir=${1:-$PWD}
if [[ ! -d $project_dir ]]; then
  printf 'NOT RUN: project directory does not exist: %s\n' "$project_dir" >&2
  exit 2
fi
if [[ ! -f $project_dir/Package.swift ]]; then
  printf 'NOT RUN: Package.swift is missing in %s; Xcode-only projects need project-specific checks\n' "$project_dir" >&2
  exit 2
fi
if ! command -v swift >/dev/null 2>&1; then
  printf 'NOT RUN: swift is not available\n' >&2
  exit 2
fi

cd "$project_dir" || exit 2
printf 'Project: %s\n' "$PWD"
printf 'Existing failures require comparison with an unchanged baseline; this script cannot attribute them to a change.\n'

build_status='NOT RUN'
test_status='NOT RUN'
format_status='NOT RUN'
failed=0
unverified=0

printf '\n[build] swift build\n'
if swift build; then
  build_status='PASS'
else
  build_status='FAIL'
  failed=1
fi

printf '\n[test] swift test\n'
if swift test; then
  test_status='PASS'
else
  test_status='FAIL'
  failed=1
fi

swift_paths=()
[[ -d Sources ]] && swift_paths+=(Sources)
[[ -d Tests ]] && swift_paths+=(Tests)
if swift format lint --help >/dev/null 2>&1; then
  if (( ${#swift_paths[@]} > 0 )); then
    printf '\n[format] swift format lint --strict --recursive %s\n' "${swift_paths[*]}"
    if swift format lint --strict --recursive "${swift_paths[@]}"; then
      format_status='PASS'
    else
      format_status='FAIL'
      failed=1
    fi
  else
    format_status='NOT RUN (no Sources or Tests directory)'
    unverified=1
  fi
else
  format_status='NOT RUN (swift format lint unavailable)'
  unverified=1
fi

printf '\nValidation results: build=%s test=%s format=%s\n' "$build_status" "$test_status" "$format_status"
if (( failed )); then
  printf 'One or more checks failed. Compare the same checks on an unchanged baseline to locate pre-existing failures.\n' >&2
  exit 1
fi
if (( unverified )); then
  printf 'One or more checks could not run; validation is incomplete.\n' >&2
  exit 2
fi
exit 0
