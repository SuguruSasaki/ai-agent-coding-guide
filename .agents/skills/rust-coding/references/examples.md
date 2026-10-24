# Examples of rule application and AI review

These examples illustrate review decisions. The original form is not always wrong. For a real finding, identify the target file, line, and callers.

## Judge an ambiguous boolean at the call site

```rust
fn create_user(name: String, active: bool) -> User { /* ... */ }
let user = create_user(name, true);
```

If `true` is unclear to a reader of the call, this is a `[G-A2]` REVIEW candidate. An `enum UserStatus { Active, Inactive }` would allow `create_user(name, UserStatus::Active)`. For a public API, inspect caller migration and compatibility. A boolean may be fine in `UserOptions { active: true }`, where the field names its purpose.

## Do not mechanically replace owned inputs with borrowed ones

```rust
struct User { name: String, status: UserStatus }

fn create_user(name: String, status: UserStatus) -> User {
    User { name, status }
}

fn is_valid_name(name: &str) -> bool {
    !name.trim().is_empty()
}
```

`create_user` can move an owned `String` into storage. Changing it to `&str` might require an allocation inside the function. `&str` is appropriate for `is_valid_name`, which only reads the value. `[G-A1]` concerns read-only borrowed parameters. Evaluate the `String` parameter separately from the boolean.

## Do not turn a recoverable failure into a panic

```rust
fn load_config(path: &std::path::Path) -> Result<String, std::io::Error> {
    std::fs::read_to_string(path)
}
```

A missing file or denied permission is an ordinary external failure. Replacing the result with `read_to_string(path).unwrap()` may support a Major finding under `[G-E1]` and `[P-E1]`. Check callers and uptime requirements before assigning severity.

## Separate async I/O from business logic

```rust
fn normalize_prompt(input: &str) -> String {
    input.trim().to_owned()
}

async fn handle_request(input: &str, client: &Client) -> Result<Response, AgentError> {
    let prompt = normalize_prompt(input);
    client.send(prompt).await
}
```

`normalize_prompt` can be tested without I/O. Review failure and cancellation behavior around `client.send`. `Client` and `AgentError` are illustrative names to be replaced with types from the target project; this snippet does not compile on its own.

## Example review finding

```text
[Minor] Boolean meaning is unclear at the call site
Location: src/user.rs:18
Rule: [G-A2] Prefer enum over bool in APIs
Problem: A reader cannot tell from create_user(name, true) that true means active status.
Proposal: Consider accepting UserStatus::Active. Migrating callers may be necessary for a public API.
Action: Human judgment required
```

Do not flag the owned `String` if the function needs to store it. Confirm actual usage before assigning a performance impact or severity.
