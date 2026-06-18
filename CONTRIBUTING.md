# Contributing

Thanks for your interest. This repo is a Claude Code plugin marketplace; each plugin bundles one or more skills.

## Repository layout

```
skills/
├── .claude-plugin/marketplace.json   # the marketplace manifest; lists every plugin
├── <plugin>/                         # one directory per plugin
│   ├── .claude-plugin/plugin.json    # the plugin manifest
│   └── skills/<skill-name>/SKILL.md  # one directory per skill, dir name == SKILL.md `name:`
├── scripts/validate-marketplace.sh
└── .github/workflows/validate.yml
```

Two rules the tooling depends on:

1. A skill's directory name **must** equal the `name:` field in its `SKILL.md` frontmatter.
2. A plugin's `.claude-plugin/plugin.json` `name` **must** equal its entry's `name` in `marketplace.json`.

## Editing a skill

The skill prose lives in `<plugin>/skills/<skill-name>/SKILL.md`. Edit it there — that file is the single source of truth (there is no separate copy in `~/.claude/skills`).

## Adding a new plugin

1. Create `<plugin>/.claude-plugin/plugin.json` (copy an existing one; bump `name`, `description`, `keywords`, start `version` at `0.0.0`).
2. Add at least one `<plugin>/skills/<skill-name>/SKILL.md`.
3. Add an entry to `.claude-plugin/marketplace.json` `plugins` with `name` and `source: "./<plugin>"`. Leave `version` out of the marketplace entry — it lives in `plugin.json` only (setting it in both is a silent-mismatch trap).
4. Run the validator (below).

## Versioning & changelog

- Each plugin is versioned independently via `version` in its `plugin.json` (semver).
- Bump the version when you change a skill's behavior, and add a line to [`CHANGELOG.md`](./CHANGELOG.md).
- `version` is omitted from `marketplace.json` on purpose — `plugin.json` always wins, so keeping it in one place avoids drift.

## Validate before you push

```bash
bash scripts/validate-marketplace.sh
```

Or, inside Claude Code:

```text
/plugin validate .
```

Then test the real install path against your local checkout:

```text
/plugin marketplace add /absolute/path/to/skills
/plugin install <plugin>@skills
```

## Pull requests

CI runs `scripts/validate-marketplace.sh` on every PR. Keep PRs focused, and describe what behavior changed and why.
