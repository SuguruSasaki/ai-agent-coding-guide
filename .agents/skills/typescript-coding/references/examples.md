# TypeScript design review examples

These are prompts for contextual review, not automatic rewrites. Check callers and compatibility before changing an exported API.

## A Boolean and a hidden failure

```ts
interface User {
  name: string;
  active: boolean;
}

interface UserStore {
  save(user: User): Promise<User>;
}

async function createUser(
  name: string, active: boolean, store: UserStore): Promise<User|undefined> {
  try {
    return await store.save({name, active});
  } catch {
    return undefined;
  }
}
```

```ts
type UserStatus = 'active'|'inactive';

interface User {
  name: string;
  status: UserStatus;
}

interface UserStore {
  save(user: User): Promise<User>;
}

async function createUser(
  name: string, status: UserStatus, store: UserStore): Promise<User> {
  if (!name.trim()) throw new Error('Name is required.');
  return store.save({name, status});
}
```

At `createUser('Ada', true, store)`, ask what `true` means and whether callers need to distinguish invalid input from a failed save. A Boolean is fine when the binary choice is obvious. The named status is a project design choice, not a Google rule requiring a union in every API. Review against [G-T06], [P-T04], and [P-T05].

If callers retry store failures but show a validation message for bad input, the first implementation supports this finding:

```text
[Major] Store failure is indistinguishable from missing user
Location: src/users/create_user.ts:14
Rule: [P-T04] Preserve recoverable error information
Problem: The catch converts every rejected save to undefined, so callers cannot retry or show the cause.
Proposal: Let the Error reject the promise, or translate it to a documented domain Error while retaining its cause.
Action: Human judgment required
```

## Type assertions do not validate tool output

```ts
interface ToolReply {
  answer: string;
}

function readAnswer(raw: unknown): string {
  return (raw as ToolReply).answer.trim();
}
```

```ts
function readAnswer(raw: unknown): string {
  if (typeof raw !== 'object' || raw === null ||
      !('answer' in raw) || typeof raw.answer !== 'string') {
    throw new Error('Invalid tool response.');
  }
  return raw.answer.trim();
}
```

The first version compiles but crashes if a tool returns `{answer: null}` or no `answer`. The second narrows at the boundary before use. Review against [G-T08] and [P-T02]. For complex payloads, a project may already have a schema validator; reuse it instead of adding a new dependency for one check. A suitable finding is **Major**, with human judgment required for the exact boundary contract.
