# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A **Claude Code plugin marketplace** — not an application. There is no build step and no runtime code; the deliverable is Markdown skills bundled into plugins. The repo root *is* the marketplace. Content (the prose inside `SKILL.md` files) is the product.

## Commands

```bash
bash scripts/validate-marketplace.sh   # validate manifests + skill naming; run before every push
```

Requires `jq`. CI (`.github/workflows/validate.yml`) runs this same script on every push to `main` and every PR — there is nothing else in CI. Inside Claude Code, `/plugin validate .` is the equivalent.

Test the real install path against a local checkout (does not need a push):

```text
/plugin marketplace add /absolute/path/to/skills
/plugin install <plugin>@skills
```

## Architecture

Three-level nesting, each level a manifest pointing down to the next:

```
.claude-plugin/marketplace.json   # lists plugins; entry = { name, source: "./<plugin>", description }
<plugin>/.claude-plugin/plugin.json   # per-plugin manifest; owns version, keywords, author
<plugin>/skills/<skill-name>/SKILL.md # the actual skill; YAML frontmatter (name, description) + prose
```

Two plugins exist today, one phase of product work each:
- `product-critique` — reviews planning artifacts before execution (`critique-spec`, then `critique-implementation-plan`). Findings return as concrete proposed edits, not a verdict.
- `qualitative-product-research` — runs discovery interviews (`practicing-user-interviews`, `live-interview-copilot`).

### Two invariants the validator enforces — breaking either fails CI

1. A skill's **directory name** must equal the `name:` in its `SKILL.md` frontmatter.
2. A plugin's `plugin.json` `name` must equal that plugin's entry `name` in `marketplace.json`.

### Shared resources via `${CLAUDE_PLUGIN_ROOT}`

A plugin can hold a file consumed by several of its skills. `qualitative-product-research/interview-principles.md` is read by both its skills at runtime via `${CLAUDE_PLUGIN_ROOT}/interview-principles.md`. Edit shared behavior there, not duplicated in each skill.

## Conventions

- **`SKILL.md` is the single source of truth** for a skill — edit it in place. There is no synced copy in `~/.claude/skills`; do not create one.
- **`description:` frontmatter is the activation trigger.** It tells the agent *when* to fire the skill (Claude Code matches on it), so phrase it as use-cases and trigger phrases, not a summary. Keep it concrete.
- **Versioning lives in `plugin.json` only**, per-plugin, semver. It is deliberately omitted from `marketplace.json` — setting it in both is a silent-mismatch trap. Bump the plugin version when a skill's behavior changes and add a line to `CHANGELOG.md` (grouped by plugin).
- New plugin start at `0.0.0`. Both plugins are flagged **experimental**; expect breaking changes.

## Adding a plugin

1. `<plugin>/.claude-plugin/plugin.json` (copy an existing one; new `name`/`description`/`keywords`, `version: "0.0.0"`).
2. At least one `<plugin>/skills/<skill-name>/SKILL.md`.
3. Add a `{ name, source: "./<plugin>" }` entry to `marketplace.json` `plugins` — no `version` field.
4. `bash scripts/validate-marketplace.sh`.
