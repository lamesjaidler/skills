# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A **Claude Code plugin marketplace** — not an application. There is no build step and no runtime code; the deliverable is Markdown skills bundled into plugins. The repo root *is* the marketplace. Content (the prose inside `SKILL.md` files) is the product.

## Commands

```bash
bash scripts/validate-marketplace.sh   # validate manifests + skill naming; run before every push
```

Requires `jq`. CI (`.github/workflows/validate.yml`) runs this same script on every push to `main` and every PR — there is nothing else in CI. Inside Claude Code, `/plugin validate .` is the equivalent.

### Iterate on a skill

Edit `SKILL.md` in place, then load the plugin **live** into a throwaway session — no install, no cache, picked up on each relaunch:

```bash
scripts/dev.sh product-critique        # wraps: claude --plugin-dir <plugin-dir>
```

This is the fast loop. Skip the release path below until a change is finished.

### Release a change (refresh the installed copy)

The plugin cache is **version-keyed**: `claude plugin update` re-copies only when `plugin.json`'s version is *higher* than what's installed. An unchanged version no-ops (`✔ already at the latest version`) and the cache stays stale — there is no `--force`. So a release is always a version bump:

```bash
scripts/release.sh product-critique 0.0.1   # validates, bumps plugin.json, refreshes the install
```

That wraps:

```bash
claude plugin marketplace update skills        # re-validates the local marketplace; does NOT re-copy content
claude plugin update product-critique@skills   # @skills qualifier is required (bare name → "not found"); restart to apply
```

Then add a `CHANGELOG.md` line and commit. `claude plugin tag <plugin>` cuts a `{name}--v{version}` git tag and checks `plugin.json` agrees with the marketplace entry.

First-run install, when nothing is installed yet (does not need a push):

```text
/plugin marketplace add /absolute/path/to/skills
/plugin install <plugin>@skills
```

## Branching

`main` is the only long-lived branch — a deliberate override of the global "feature branches off `development`" default, since this is a low-blast-radius marketplace with no integration tier to protect. Work on short feature branches cut from `main` and open a PR. CI validates every PR and every push to `main`. Do not push or merge without explicit instruction.

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
- **Versioning lives in `plugin.json` only**, per-plugin, semver. It is deliberately omitted from `marketplace.json` — setting it in both is a silent-mismatch trap. Bump the plugin version when a skill's behavior changes and add a line to `CHANGELOG.md` (grouped by plugin). The bump is also the **cache-refresh mechanism** (see *Release a change*) — leaving the version unchanged leaves the installed copy stale.
- New plugin start at `0.0.0`. Both plugins are flagged **experimental**; expect breaking changes.

## Adding a plugin

1. `<plugin>/.claude-plugin/plugin.json` (copy an existing one; new `name`/`description`/`keywords`, `version: "0.0.0"`).
2. At least one `<plugin>/skills/<skill-name>/SKILL.md`.
3. Add a `{ name, source: "./<plugin>" }` entry to `marketplace.json` `plugins` — no `version` field.
4. `bash scripts/validate-marketplace.sh`.
