#!/usr/bin/env bash
# Run an existing TypeScript package's checks without installing dependencies.
set -u
set -o pipefail

usage() {
  cat <<'USAGE'
Usage: validate.sh [project-directory]

Run existing typecheck, lint, and test package scripts. If no typecheck script
exists, use the project's local tsc with tsconfig.json when available. Run an
existing format:check script if present. Never install dependencies. Report
missing checks as NOT RUN; exit 1 on failure, 2 if required checks could not run.
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
if [[ ! -d $project_dir || ! -f $project_dir/package.json ]]; then
  printf 'NOT RUN: package.json is missing in %s\n' "$project_dir" >&2
  exit 2
fi
if ! command -v node >/dev/null 2>&1; then
  printf 'NOT RUN: node is unavailable\n' >&2
  exit 2
fi

cd "$project_dir" || exit 2
manager=$(node -e '
  const fs = require("node:fs");
  const p = JSON.parse(fs.readFileSync("package.json", "utf8"));
  const declared = p.packageManager?.split("@")[0];
  if (declared) process.stdout.write(declared);
  else if (fs.existsSync("pnpm-lock.yaml")) process.stdout.write("pnpm");
  else if (fs.existsSync("yarn.lock")) process.stdout.write("yarn");
  else if (fs.existsSync("bun.lock") || fs.existsSync("bun.lockb")) process.stdout.write("bun");
  else process.stdout.write("npm");
') || {
  printf 'NOT RUN: package.json could not be parsed\n' >&2
  exit 2
}
case $manager in
  npm|pnpm|yarn|bun) ;;
  *) printf 'NOT RUN: unsupported package manager: %s\n' "$manager" >&2; exit 2 ;;
esac
if ! command -v "$manager" >/dev/null 2>&1; then
  printf 'NOT RUN: package manager %s is unavailable; no dependencies were installed\n' "$manager" >&2
  exit 2
fi

has_script() {
  node -e '
    const p = require("./package.json");
    const script = p.scripts?.[process.argv[1]];
    process.exit(typeof script === "string" && script.trim() ? 0 : 1);
  ' "$1"
}

printf 'Project: %s\nPackage manager: %s\n' "$PWD" "$manager"
printf 'Checks use the existing package configuration and installed dependencies. Compare failures with an unchanged baseline before attributing them to this change.\n'

typecheck_status='NOT RUN'
lint_status='NOT RUN'
test_status='NOT RUN'
format_status='NOT RUN (no format:check script)'
failed=0
unverified=0

if has_script typecheck; then
  printf '\n[typecheck] %s run typecheck\n' "$manager"
  if "$manager" run typecheck; then typecheck_status='PASS'; else typecheck_status='FAIL'; failed=1; fi
elif [[ -f tsconfig.json && -x node_modules/.bin/tsc ]]; then
  printf '\n[typecheck] node_modules/.bin/tsc --noEmit --project tsconfig.json\n'
  if node_modules/.bin/tsc --noEmit --project tsconfig.json; then
    typecheck_status='PASS'
  else
    typecheck_status='FAIL'
    failed=1
  fi
else
  typecheck_status='NOT RUN (no typecheck script or local tsc plus tsconfig.json)'
  unverified=1
fi

if has_script lint; then
  printf '\n[lint] %s run lint\n' "$manager"
  if "$manager" run lint; then lint_status='PASS'; else lint_status='FAIL'; failed=1; fi
else
  lint_status='NOT RUN (no lint script)'
  unverified=1
fi

if has_script test; then
  printf '\n[test] %s run test\n' "$manager"
  if "$manager" run test; then test_status='PASS'; else test_status='FAIL'; failed=1; fi
else
  test_status='NOT RUN (no test script)'
  unverified=1
fi

if has_script format:check; then
  printf '\n[format] %s run format:check\n' "$manager"
  if "$manager" run format:check; then format_status='PASS'; else format_status='FAIL'; failed=1; fi
fi

printf '\nValidation results: typecheck=%s lint=%s test=%s format=%s\n' \
  "$typecheck_status" "$lint_status" "$test_status" "$format_status"
if (( failed )); then
  printf 'One or more checks failed. Use an unchanged baseline to distinguish existing failures.\n' >&2
  exit 1
fi
if (( unverified )); then
  printf 'One or more required checks could not run; validation is incomplete.\n' >&2
  exit 2
fi
exit 0
