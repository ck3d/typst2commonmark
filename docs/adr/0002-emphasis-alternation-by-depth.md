# Emphasis marker alternation by nesting depth

Emphasis and strong-emphasis use `*`/`**` at the outer layer and `_`/`__` when nested inside other emphasis. The switch is controlled by a single `emph-depth` counter in the walker's context: depth 0 uses `*`/`**`, anything deeper uses `_`/`__`.

**Why this exists:** CommonMark does not allow same-marker emphasis to nest — `***x***` is parsed as bold+italic of `x`, but `***x**y*` is unspecified. To emit valid CommonMark for nested emphasis (e.g., `strong([emph([text("x")])])` → `**_x_**`), the inner marker must differ from the outer one.

**Considered Options:**

- **Always `*`/`**`: invalid CommonMark for nested emphasis. Rejected.
- **HTML `<em>`/`<strong>` spans**: valid CommonMark, but produces ugly, non-readable markdown for a trivial case. Rejected.
- **Always alternate** (current approach): produces correct CommonMark for depth 1–2, which covers virtually all real-world documents. Chosen.

**Consequences:**

- **Emphasis at depth > 2 is currently unsupported.** Nesting emphasis three levels deep (e.g., `emph` inside `strong` inside `emph`) produces `_` inside `_`, which is also invalid CommonMark. Fixing this would require cycling through 3+ distinct marker styles (which CommonMark itself doesn't support without HTML fallback). The fix is deferred; documents rarely nest emphasis that deeply.
- Adding new emphasis-like constructs (e.g., strikethrough) must not interfere with `emph-depth` semantics.
- The output is stable: once a document has been converted, the emphasis markers in it are part of the consumer-facing format — changing the rule later would break every downstream user.
