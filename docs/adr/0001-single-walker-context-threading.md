# Single recursive walk with context-threaded dispatch

The converter uses a single `walk(elem, ctx) → string` function dispatching via `if/else` on `elem.func()`, with a context record threaded from parent to child carrying rendering mode, emphasis depth, and list indentation. Each call returns a string with **no leading or trailing whitespace**; callers handle separation (`\n\n` in block mode, `""` in inline mode).

**Considered Options:**

- **Handler dictionary** (`func → handler`): Typst's script model has no clean first-class function dispatch by value, and for ~15 element types an `if/else` chain is the idiomatic shape. Rejected.
- **Two-pass (build AST, then render)**: The Typst content tree is already a well-formed AST, so an intermediate representation would be pure overhead. Rejected.
- **Mode-less traversal with heuristics** (guess block vs. inline from element type): Fragile — emphasis rendering, quoting of nested lists, and escape rules all depend on context. Rejected.

**Consequences:**

- Adding a new element type means adding one `else if` branch. The `<!-- dropped: … -->` fallback is what makes this safe to grow.
- The `walk` function is the single place to touch for any new element type — that's by design. Splitting it would scatter related decisions.
- The no-whitespace invariant is essential to correctness — if a child returned `" body"`, every caller's separator logic would be wrong. `<!-- dropped: … -->` output from unrecognized elements satisfies this invariant (no leading/trailing whitespace) so the pattern extends safely.
