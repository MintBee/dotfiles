---
name: "write-tech-note"
description: "Guide technical writing about technical problems the user encountered and how they solved them. Use when the user asks Codex to outline, draft, revise, or structure a technical note, engineering blog post, postmortem-style explanation, troubleshooting write-up, or problem-solution article, especially when the writing should start from the problem, decompose subproblems, explain hypotheses and verification, present an abstracted solution, and address concerns."
---

# Write Tech Note

## Core Rule

Guide the user through two phases:

1. Outline writing
2. Full writing

Do not write the full piece before the outline is clear, unless the user explicitly asks to skip the outline phase.

## Phase 1: Outline Writing

Start from the user's argument, notes, rough outline, incident, or solution. If the central problem, intended audience, or solved outcome is unclear, ask only the minimum questions needed before outlining.

State assumptions before the outline when you infer missing context.

Write the outline as the argument's skeleton. Treat each outline sentence as a structural claim that supports the whole piece, not as a decorative section title. A roughly thousand-word piece needs about ten outline sentences. Keep the fundamental outline between ten and fifteen sentences even for a longer piece; if the planned piece is longer than a thousand words, create sub-outlines under the primary outline sentences instead of making the top-level outline longer.

Build the outline in this order:

1. Raise the central technical problem first.
2. Explain why the problem matters in the actual engineering context.
3. Split the central problem into connected subproblems.
4. Define the distinctive nature of each subproblem: constraints, failure mode, ambiguity, cost, or tradeoff.
5. For unclear causes, include a non-trivial hypothesis, how it was verified, and what was learned.
6. Present the solution for each subproblem at the right abstraction level.
7. Exclude details that are not central to understanding why the solution works.
8. Identify reasonable concerns introduced by the solution.
9. Show why each concern is not a problem, or explain how it was handled.
10. End with the durable technical lesson, not a vague summary.

After writing the outline, ask the user whether to revise the outline or continue to the full writing.

## Phase 2: Full Writing

Expand only from an approved or user-provided outline. Preserve the outline's argument order unless the prose reveals a structural problem; if it does, point out the issue and propose a revised outline before continuing.

Write in a direct technical style:

- Open with the problem, not background trivia.
- Keep every section tied to the central problem.
- Introduce implementation details only when they explain a cause, constraint, decision, or result.
- Use abstractions to explain how the solution works, but keep the abstraction grounded in the real problem.
- When root cause was uncertain, narrate the hypothesis and verification process instead of pretending the answer was obvious.
- Make tradeoffs explicit.
- Address credible objections before the conclusion.
- Conclude with what the reader can reuse in a similar situation.

## Quality Checks

Before finalizing an outline or draft, check:

- Does the piece begin by making the technical problem worth reading about?
- Does each subproblem clearly descend from the central problem?
- Does each solution match the specific nature of its subproblem?
- Are hypotheses and verification shown where the cause was non-obvious?
- Is the explanation abstract enough to be reusable, without hiding the key mechanics?
- Are irrelevant implementation details intentionally omitted?
- Are concerns, risks, or objections handled rather than ignored?
- Could a reader explain both what changed and why that solved the problem?

If the answer to any check is no, revise before presenting the result as final.
