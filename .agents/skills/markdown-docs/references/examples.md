# Markdown review examples

Review these examples against the reader's task and hosting renderer. They are
not templates to impose on every document.

## Reader can find and run the setup step

Weak:

````markdown
# Setup

See [here](https://example.com/long/path) and run the command below.

```sh
tool init --dir ./project
```
````

Improved for a repository README:

````markdown
# Agent setup

Install the agent tool, then initialize it in the project directory.

1. Follow the [agent installation guide](https://example.com/long/path).
2. Initialize the project:

   ```sh
   tool init --dir ./project
   ```
````

The revised heading says what the page covers, the link label names its
destination, and the numbered steps state an order. Verify the real
installation destination and command before publishing. Relevant rules:
[G-M02], [G-M07], [G-M08], and [P-M05].

## Review finding with reader impact

Suppose `README.md:28` says to run `npm install`, while the project requires
a different package manager and lockfile. The review should describe the
mismatch, not merely request line wrapping:

```text
[Major] Setup command uses the wrong package manager
Location: README.md:28
Rule: [G-M01] Fresh and accurate docs; [P-M05] Verify commands
Problem: Following the command produces an unsupported lockfile and does not prepare the documented test workflow.
Proposal: Replace it with the package manager command used by this repository, after checking the project configuration.
Action: Human judgment required
```

For a purely mechanical trailing-space finding, cite [G-M05] and mark the fix
automatable. For a broken link, verify the destination and reader path before
deciding its severity.
