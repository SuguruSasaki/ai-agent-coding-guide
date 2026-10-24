#!/usr/bin/env bash
# Run a validator installed with the project's coding-guide skills.
set -u

usage() {
  cat <<'USAGE'
Usage: ./.agents/validate [rust|swift|typescript|shell] [target]

With one installed code validator, the language argument may be omitted.
The default target is the project root. Pass a package directory for a
monorepo, or a file for the Shell validator. Markdown checks are described
in the markdown-docs skill and do not have a validator script.
USAGE
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  usage
  exit 0
fi
if (( $# > 2 )); then
  usage >&2
  exit 2
fi

project_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P) || exit 2
skills_dir=$project_root/.agents/skills

if (( $# == 0 )); then
  available_count=0
  for candidate in rust swift typescript shell; do
    case $candidate in
      rust) skill=rust-coding ;;
      swift) skill=swift-coding ;;
      typescript) skill=typescript-coding ;;
      shell) skill=shell-coding ;;
    esac
    if [[ -x $skills_dir/$skill/scripts/validate.sh ]]; then
      available_count=$((available_count + 1))
      language=$candidate
    fi
  done
  if (( available_count != 1 )); then
    if (( available_count == 0 )); then
      printf 'No code validator is installed in %s\n' "$project_root" >&2
    else
      printf 'Multiple validators are installed; specify a language.\n' >&2
    fi
    usage >&2
    exit 2
  fi
else
  language=$1
fi

case $language in
  rust) skill=rust-coding ;;
  swift) skill=swift-coding ;;
  typescript) skill=typescript-coding ;;
  shell) skill=shell-coding ;;
  *)
    printf 'Unknown validator: %s\n' "$language" >&2
    usage >&2
    exit 2
    ;;
esac

validator=$skills_dir/$skill/scripts/validate.sh
if [[ ! -x $validator ]]; then
  printf 'Validator is not installed: %s\n' "$language" >&2
  exit 2
fi

target=${2:-$project_root}
exec "$validator" "$target"
