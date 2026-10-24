# Swift design review examples

These are review prompts, not universal rewrites. Verify call sites and compatibility before changing a public API.

## Ambiguous state and failure

```swift
// Candidate for review: a Boolean argument is unclear at the call site,
// and nil erases the reason why creation failed.
struct User {
  let name: String
  let isActive: Bool
}

protocol UserStore {
  func save(name: String, active: Bool) async throws -> User
}

func createUser(name: String, active: Bool, using store: any UserStore) async -> User? {
  guard !name.isEmpty else { return nil }
  return try? await store.save(name: name, active: active)
}
```

```swift
struct User {
  let name: String
  let status: UserStatus
}

enum UserStatus {
  case active
  case inactive
}

enum CreateUserError: Error {
  case invalidName
}

protocol UserStore {
  func save(name: String, status: UserStatus) async throws -> User
}

func createUser(name: String, status: UserStatus, using store: any UserStore) async throws -> User {
  guard !name.isEmpty else { throw CreateUserError.invalidName }
  return try await store.save(name: name, status: status)
}
```

At `createUser(name: "A", active: true, using: store)`, ask whether the flag's meaning is obvious, whether future states are likely, and whether callers must distinguish invalid input from a failed save. A `Bool` is fine when it is inherently binary and clearly labeled; `UserStatus` is useful when it names a domain choice. Swift `String` has value semantics, so do **not** transplant Rust's `&str` ownership rule into Swift. Review against [G-S05], [G-S07], and [P-S04].

Example finding for the first signature, if callers handle those errors differently:

```text
[Major] Creation failures lose their cause
Location: Sources/Users/UserService.swift:12
Rule: [G-S07] Optional and error design; [P-S04] Recoverable agent I/O failures
Problem: nil represents both invalid input and a failed save, so callers cannot respond correctly.
Proposal: Return User with throws; throw invalidName and propagate the store error. Check compatibility with callers.
Action: Human judgment required
```

## Actor state across suspension

```swift
protocol TokenProvider: Sendable {
  func refresh(_ current: String?) async throws -> String
}

actor TokenStore {
  private var token: String?

  func refresh(using provider: TokenProvider) async throws {
    let current = token
    let replacement = try await provider.refresh(current)
    token = replacement
  }
}
```

If overlapping refreshes are possible, a second call may update `token` during the `await`, then the first call overwrites it. Review the intended ordering and consider a revision check, serialization of refresh requests, or another boundary. This is [P-S02], not a Google style rule, and should be reported only when the race matters to the application.
