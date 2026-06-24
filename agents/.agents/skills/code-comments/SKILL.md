--- name: code-comments
description: Guide comment judgment while writing, editing, refactoring, reviewing, or generating any kind of code. Use whenever Codex touches code so comments are added only when they reduce cognitive load by capturing precision, intuition, rationale, interface contracts, side effects, preconditions, exceptions, limitations, design decisions, rejected alternatives, or non-obvious implementation intent; avoid comments that merely restate syntax or describe trivial code
---

# Code Comments

## Overview

Use comments to preserve design knowledge that code cannot express precisely. Treat comments as part of the abstraction boundary: they should reduce the reader's cognitive load and reveal obscure decisions, not narrate the syntax.

## Comment-First Design

Before writing a non-trivial class, method, function, module, or complex block:

1. Draft the interface comment before finalizing the signature.
2. Draft implementation comments before writing tricky internal logic.
3. Use the comments as a design test. If the interface comment is long, hard to state, or full of special cases, simplify the abstraction before coding when the task allows it.

Do not force comments into trivial code. Prefer clear names and simpler code when they communicate the idea fully.

## Write Comments When

Add a comment when it contributes at least one of these:

- Precision: constraints, dependencies between arguments, valid ranges, return semantics, side effects, exceptions, preconditions, ordering requirements, concurrency limits, or lifecycle rules.
- Intuition: the mental model a caller or maintainer needs in order to understand what the abstraction represents or why a block exists.
- Rationale: design decisions, rejected alternatives, external-library bugs, compatibility workarounds, performance tradeoffs, hardware or platform quirks, or bug fixes whose purpose is not obvious locally.

Favor comments for deep modules with a thin public surface and substantial implementation beneath it. These modules benefit most from explicit abstraction boundaries.

## Avoid Comments When

Do not add a comment when it only translates nearby code into natural language, repeats the entity name, or describes implementation details the caller does not need.

Avoid comments on trivial classes, obvious assignments, straightforward control flow, and code that should be simplified instead. If the comment says what the next line says, delete the comment or improve the code.

## Interface Comments

Write interface comments for callers. Keep implementation details out unless the caller must know them to use the abstraction correctly.
Interface comments MUST only be on the interfaces unless implementing classes have extra design decisions.

For a class or module, describe:

- What abstraction it provides.
- What each instance represents.
- Important capabilities and limitations.
- Constraints such as thread-safety, lifecycle, ownership, persistence, or external effects.

For a method or function, describe:

- Behavior as the caller observes it.
- Each argument's meaning and constraints, especially dependencies between arguments.
- Return value semantics, including sentinel values and ownership expectations.
- Side effects that affect future system behavior.
- Exceptions or errors that can escape.
- Preconditions that must be satisfied before calling it.

## Implementation Comments

Write implementation comments for maintainers. Place them near code whose intent, reason, or non-obvious structure cannot be inferred from the code alone.

Explain what the code is trying to accomplish and why the chosen approach is necessary. Do not explain ordinary syntax, standard library calls, or mechanics that are already evident from the surrounding code.

Watch out that most methods are so short and simple that they don’t need any implementation comments: given the code and the interface comments, it’s easy to figure out how a method works.

### Write Implementation Comments When

- Before each of the major blocks to provide a high-level (more abstract) description of what that block does
- Before long and complex loop

### Avoid Implementation Comments When

- Intent or reason appear on the callee functions. Don't duplicate the comments on the caller
- Codes follow standard patterns, so the intent is already implicit and obvious

## Review Checklist

Before finishing a code change:

1. Check new or modified comments for added abstraction, precision, intuition, or rationale.
2. Remove comments that merely restate code introduced by the change.
3. Ensure interface comments do not leak unnecessary implementation details.
4. Ensure implementation comments do not duplicate interface documentation.
5. Prefer different words from the identifier being documented so the comment adds meaning instead of repetition.
