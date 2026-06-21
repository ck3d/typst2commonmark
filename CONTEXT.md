# to-commonmark Domain Model

## Ubiquitous Language

**walker / walk**
The single recursive function that converts a Typst content tree into a CommonMark string. Dispatches by element type and threads context from parent to child.

**context (ctx)**
A record threaded through the walker carrying rendering state:
- `mode`: `"block"` or `"inline"` — determines element separation and escape rules
- `emph-depth`: nesting level of emphasis, controls `*` vs `_` alternation
- `list-indent`: accumulated indentation string for nested lists

**mode**
One of two rendering contexts:
- **block mode**: elements separated by `\n\n`, used for document-level content
- **inline mode**: elements concatenated with empty string, used for text within paragraphs, headings, etc.

**emphasis alternation**
Outer emphasis uses `*`/`**`, nested emphasis uses `_`/`__`. Controlled by `emph-depth` counter. CommonMark requires different markers for nested emphasis.

**inline-special characters**
The set `\``*_[]<` that must be backslash-escaped in inline text contexts.

**dropped element comment**
The HTML comment `<!-- dropped: func-name -->` emitted for unrecognized elements. Preserves the no-whitespace invariant.

**no-whitespace invariant**
Every `walk` call returns a string with no leading or trailing whitespace. Callers handle separation; children never produce their own padding.

## Architecture Decisions

See `docs/adr/` for formal decisions:
- 0001: Single recursive walker with context-threaded dispatch
- 0002: Emphasis marker alternation by nesting depth
