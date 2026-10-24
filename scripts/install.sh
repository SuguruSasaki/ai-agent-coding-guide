#!/usr/bin/env bash
# Install selected coding-guide skills and agent instructions into a project.
set -u
set -o pipefail

usage() {
  cat <<'USAGE'
Usage: ai-agent-coding-guide SKILL [SKILL ...]

SKILL is one of: rust, swift, typescript, shell, markdown. Choose only the
skills used by the current project. Run again to add more skills later.
Existing skill files are never overwritten.
USAGE
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  usage
  exit 0
fi
if (( $# < 1 )); then
  usage >&2
  exit 2
fi

script_path=${BASH_SOURCE[0]}
while [[ -L $script_path ]]; do
  script_dir=$(cd "$(dirname "$script_path")" && pwd -P) || exit 1
  link_target=$(readlink "$script_path") || exit 1
  case $link_target in
    /*) script_path=$link_target ;;
    *) script_path=$script_dir/$link_target ;;
  esac
done
source_root=$(cd "$(dirname "$script_path")/.." && pwd -P) || exit 1
target_root=$(pwd -P) || exit 1
if [[ $source_root == "$target_root" ]]; then
  printf 'Choose a project other than this guide repository.\n' >&2
  exit 2
fi

skills_dir=$target_root/.agents/skills
agents_file=$target_root/AGENTS.md
skill_names=()
selected_names=' '
for requested in "$@"; do
  case $requested in
    rust) name=rust-coding ;;
    swift) name=swift-coding ;;
    typescript) name=typescript-coding ;;
    shell) name=shell-coding ;;
    markdown) name=markdown-docs ;;
    *)
      printf 'Unknown skill: %s\n' "$requested" >&2
      usage >&2
      exit 2
      ;;
  esac
  if [[ $selected_names == *" $name "* ]]; then
    printf 'Skill specified more than once: %s\n' "$requested" >&2
    exit 2
  fi
  selected_names+="$name "
  skill_names+=("$name")
done
start_marker='<!-- ai-agent-coding-guide:start -->'
end_marker='<!-- ai-agent-coding-guide:end -->'

for path in "$target_root/.agents" "$skills_dir"; do
  if [[ -L $path || ( -e $path && ! -d $path ) ]]; then
    printf 'Expected a real directory: %s\n' "$path" >&2
    exit 2
  fi
done
if [[ -L $agents_file || ( -e $agents_file && ! -f $agents_file ) ]]; then
  printf 'Expected a regular file: %s\n' "$agents_file" >&2
  exit 2
fi

for name in "${skill_names[@]}"; do
  destination=$skills_dir/$name
  if [[ -e $destination || -L $destination ]]; then
    if [[ ! -d $destination || -L $destination ]] || \
        ! diff -qr "$source_root/.agents/skills/$name" \
          "$destination" >/dev/null; then
      printf 'Existing skill differs; resolve it before installing: %s\n' \
        "$destination" >&2
      exit 2
    fi
  fi
done

has_start=0
has_end=0
if [[ -f $agents_file ]]; then
  if grep -Fq "$start_marker" "$agents_file"; then has_start=1; fi
  if grep -Fq "$end_marker" "$agents_file"; then has_end=1; fi
fi
if (( has_start != has_end )); then
  printf 'Incomplete coding-guide block in %s\n' "$agents_file" >&2
  exit 2
fi

mkdir -p "$skills_dir" || exit 1
for name in "${skill_names[@]}"; do
  destination=$skills_dir/$name
  if [[ ! -e $destination ]]; then
    cp -R "$source_root/.agents/skills/$name" "$destination" || exit 1
    printf 'Installed %s\n' "$name"
  else
    printf 'Already installed %s\n' "$name"
  fi
done

if (( ! has_start )); then
  if [[ -s $agents_file ]]; then
    printf '\n\n' >> "$agents_file" || exit 1
  else
    printf '# Agent instructions\n\n' >> "$agents_file" || exit 1
  fi
  cat >> "$agents_file" <<'BLOCK' || exit 1
<!-- ai-agent-coding-guide:start -->
## Coding guide skills

For code and repository Markdown work, read and apply the matching
`.agents/skills/<skill-name>/SKILL.md` installed in this project. Apply only
skills relevant to the files and task. Invoke the matching `$skill-name` in
Codex when explicit skill selection is needed.

Use both relevant skills when changing code and Markdown together. Before
editing, inspect the existing design, callers, and build configuration. After
editing code, run the matching skill's validation script against this project
and review decisions that automated checks cannot judge. For Markdown, follow
its checks. For review-only requests, do not edit. Report unrun checks as
unverified. Project-specific instructions take precedence when they conflict.
<!-- ai-agent-coding-guide:end -->
BLOCK
  printf 'Updated %s\n' "$agents_file"
else
  printf 'Already configured %s\n' "$agents_file"
fi

printf 'Review the new files and AGENTS.md changes in %s\n' "$target_root"
