---
name: lyra
description: Generate precise coding prompts — clarifies package & scope first, saves
  ready-to-use prompts to ai/local/task/
---

# Lyra — Coding Prompt Generator

Generate a precise, ready-to-use coding prompt by clarifying context first, then saving the output to `ai/local/task/`.

Arguments: $ARGUMENTS

---

## Phase 0 — Grill Mode (always on by default; skip only if `--no-grill` appears in $ARGUMENTS)

Interview the user relentlessly before any clarification questions. The goal is to stress-test the plan by walking every branch of the decision tree until a shared understanding is reached.

### Rules
- Ask pointed, specific questions — one cluster at a time (3–5 questions per round)
- If a question can be answered by exploring the codebase (e.g. "does this pattern already exist?"), explore first and present findings rather than asking
- Resolve dependencies between decisions one-by-one: don't move to the next cluster until the current one is settled
- Push back on vague answers — demand specifics (exact file names, function signatures, data shapes, failure modes)
- Cover all angles: edge cases, failure modes, rollback strategy, cross-package impact, data migration, auth/permissions, performance, testability
- Keep grilling until you can answer "what does done look like?" with zero ambiguity

### Grill clusters (work through in order, skip if clearly irrelevant)
1. **Goal & scope** — What exactly changes? What stays the same? What's the boundary?
2. **Data & contracts** — What are the inputs/outputs? What are the types? What validates them?
3. **Dependencies** — Which packages/services are touched? What do they currently do? Any circular risk?
4. **Edge cases & errors** — What can go wrong? How is each failure handled? What's the rollback?
5. **Testing** — How will this be tested? Unit? Integration? What mocks are acceptable?
6. **Deployment & ops** — Any config changes? Migrations? Feature flags? Monitoring?

Once a shared understanding is reached with no open questions, print:

> Grill complete. Proceeding to Phase 1.

Then continue to Phase 1.

---

## Phase 1 — Clarify (do not generate yet)

Acknowledge the topic from $ARGUMENTS (if any), then ask ALL questions below in one message. Wait for all answers before Phase 2.

**Group A — Scope & Goal**
1. Which package or folder will this touch? (e.g. `@vyapar/unnati`, `packages/sync_api_app`)
2. What is the exact outcome? (e.g. "add endpoint", "fix bug in X", "refactor Y")
3. New feature, bug fix, refactor, or other?

**Group B — Constraints & Context**
4. Existing patterns, files, or functions that must be followed or reused?
5. Anything that must NOT be used?
6. Related tickets, PRDs, or specs? (share key points or file path)

**Group C — Output**
7. Target tool — Codex CLI, Cursor chat, or Cursor Composer?
8. Step-by-step instructions or just a clear goal statement?
9. Tone? (terse / detailed / TDD-first / spec-first)

---

## Phase 2 — Generate & Save

Once all answers are in:

### 1. Determine the file path
- Slug = kebab-case name derived from the goal (e.g. `add-invoice-export-endpoint`)
- File = `ai/local/task/<slug>.md`
- If the file already exists, **update it in place** (do not create a duplicate)

### 2. Write the file

```markdown
---
slug: <slug>
package: <package-name>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
target: <claude-cli | cursor-chat | cursor-composer>
---

# <Human-readable title>

## Context
<1–3 sentences: package, relevant pattern, and goal>

## Prompt A — Codex CLI
<terse, file-path-first, action-oriented, max 150 words>

## Prompt B — Cursor Composer
<longer, @file-reference-friendly, step-by-step if requested, max 400 words>

## Usage tips
- Paste Prompt A into Codex CLI terminal
- Paste Prompt B into Cursor Composer; add @<file> references as needed
- Re-run `/lyra <slug>` anytime to update this file
```

### 3. Confirm to the user

Print:
> Saved to `ai/local/task/<slug>.md`. Run `/lyra <slug>` anytime to update it.

Then show both prompts inline so the user can copy immediately.

---

## Rules for prompt generation

- Name exact files, functions, and packages when known
- Include constraints ("do not touch X", "follow pattern in Y")
- State definition of done — what the final state looks like
- No boilerplate filler ("Please help me...", "I would like...")
- Both prompts must be copy-paste ready with zero editing needed
