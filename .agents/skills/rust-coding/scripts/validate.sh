#!/usr/bin/env bash
# Validate a Rust Cargo workspace without changing source files.
set -u
set -o pipefail

usage() {
  cat <<'USAGE'
Usage: validate.sh [project-directory]

Run cargo fmt --all -- --check, cargo clippy --workspace --all-targets -- -D warnings,
and cargo test --workspace in a Cargo project. The default directory is the
current working directory. Results and command output are printed to stdout.
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
if [[ ! -f $project_dir/Cargo.toml ]]; then
  printf 'NOT RUN: Cargo.toml is missing in %s\n' "$project_dir" >&2
  exit 2
fi
if ! command -v cargo >/dev/null 2>&1; then
  printf 'NOT RUN: cargo is not available\n' >&2
  exit 2
fi

cd "$project_dir" || exit 2
printf 'Project: %s\n' "$PWD"
printf 'Checks use this Cargo.toml and the active toolchain. Existing failures require comparison with an unchanged baseline; this script cannot attribute them to a change.\n'

fmt_status='NOT RUN'
clippy_status='NOT RUN'
test_status='NOT RUN'
failed=0

printf '\n[fmt] cargo fmt --all -- --check\n'
if cargo fmt --all -- --check; then
  fmt_status='PASS'
else
  fmt_status='FAIL'
  failed=1
fi

printf '\n[clippy] cargo clippy --workspace --all-targets -- -D warnings\n'
if cargo clippy --workspace --all-targets -- -D warnings; then
  clippy_status='PASS'
else
  clippy_status='FAIL'
  failed=1
fi

printf '\n[test] cargo test --workspace\n'
if cargo test --workspace; then
  test_status='PASS'
else
  test_status='FAIL'
  failed=1
fi

printf '\nValidation results: fmt=%s clippy=%s test=%s\n' "$fmt_status" "$clippy_status" "$test_status"
if (( failed )); then
  printf 'One or more checks failed. Compare the same commands on an unchanged baseline to distinguish existing failures from this change.\n' >&2
  exit 1
fi
exit 0
