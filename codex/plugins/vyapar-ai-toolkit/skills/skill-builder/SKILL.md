---
name: skill-builder
description: Create or update Codex skills with valid metadata, focused workflows, progressive disclosure, and optional scripts, references, or assets. Use when designing reusable Codex instructions or converting a repeated workflow into a skill.
---

# Build a Codex skill

Create a focused skill that another Codex session can discover and follow without relying on hidden context.

## Choose the scope

1. Identify one repeatable user goal.
2. Record the inputs, required decisions, success criteria, and stopping conditions.
3. Split workflows that have different triggers or outputs into separate skills.
4. Prefer instructions alone unless deterministic processing requires a script.

## Choose the location

- Repository skill: `<repo-root>/.agents/skills/<skill-name>/`
- User skill: `~/.agents/skills/<skill-name>/`
- Plugin skill: `<plugin-root>/skills/<skill-name>/`

Keep each skill in a direct child directory of its applicable `skills/` folder. Name the directory with lowercase letters, digits, and hyphens only.

## Create `SKILL.md`

Use exactly the required `name` and `description` metadata:

```markdown
---
name: review-api-change
description: Review an API change for compatibility, security, and test coverage. Use when Codex is asked to assess a proposed or implemented API modification.
---

# Review an API change

1. Inspect the changed contract and affected callers.
2. Check compatibility and security boundaries.
3. Verify focused tests.
4. Report findings by severity with file references.
```

Metadata requirements:

- Match `name` to the containing directory.
- Use lowercase kebab case and keep the name under 64 characters.
- State both what the skill does and when it should trigger in `description`.
- Put detailed procedure in the body, not the description.
- Do not add unrelated frontmatter fields.

## Add resources only when useful

```text
skill-name/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── scripts/
├── references/
└── assets/
```

- Put deterministic repeated operations in `scripts/`.
- Put policies, schemas, and long examples in `references/`.
- Put output templates and reusable files in `assets/`.
- Add `agents/openai.yaml` only for useful UI metadata or declared MCP dependencies.
- Link every supporting resource from `SKILL.md` and state when to use it.
- Keep references shallow and avoid duplicating the same content.

## Keep context efficient

- Assume Codex already understands common software practices.
- Keep the main workflow concise and imperative.
- Move detailed variants out of `SKILL.md` when it approaches 500 lines.
- Avoid auxiliary README, changelog, and installation files inside the skill.

## Validate

1. Confirm the directory name matches the frontmatter `name`.
2. Confirm `SKILL.md` has a non-empty description with a clear trigger.
3. Check all linked resources exist.
4. Run the available Codex skill validator when present.
5. Test direct, indirect, incomplete, negative, and edge-case prompts.

Codex detects repository and user skill changes automatically. Restart Codex if a new or changed skill does not appear.
