# Shell design review examples

These examples prompt reasoning about real inputs and callers; they do not
require rewriting every script into the same shape.

## Forward arguments without splitting them

```bash
run_tool() {
  local flags='--mode safe --name Jane Doe'
  tool $flags "$@"
}
```

If the name and values are separate arguments, the string version splits
`Jane Doe`. An array preserves boundaries:

```bash
run_tool() {
  local flags=(--mode safe --name 'Jane Doe')
  tool "${flags[@]}" "$@"
}
```

Review the expected CLI shape before changing it. The improvement follows
[G-S06](google-shell-style.md), but ShellCheck alone may not know the intended
arguments.

## Preserve failure from command substitution

```bash
load_token() {
  local token="$(fetch_token)"
  printf '%s\n' "${token}"
}
```

`local` can return success even when `fetch_token` fails. Split declaration
from assignment and handle failure:

```bash
load_token() {
  local token
  if ! token="$(fetch_token)"; then
    printf 'Unable to fetch token\n' >&2
    return 1
  fi
  printf '%s\n' "${token}"
}
```

At the original assignment, a supported review finding is:

```text
[Major] Token retrieval failure is masked
Location: scripts/load_token.sh:2
Rule: [G-S08] Separate local declaration and command substitution
Problem: A failed fetch_token appears successful; callers may use an empty token.
Proposal: Declare token separately, check assignment status, and return nonzero.
Action: Human judgment required
```

## Check pipeline assumptions

```bash
producer | while IFS= read -r item; do
  last_item="${item}"
done
printf '%s\n' "${last_item}"
```

The loop runs in a subshell in ordinary Bash pipeline semantics, so
`last_item` does not retain its assignment. Use process substitution when
retaining state matters, then review how a failed producer will be reported:

```bash
while IFS= read -r item; do
  last_item="${item}"
done < <(producer)
```

Process substitution fixes the scope issue but does not automatically
propagate `producer`'s exit status. The correct design depends on whether
failure must stop the caller; check [G-S03](google-shell-style.md) and
[G-S08](google-shell-style.md) together.
