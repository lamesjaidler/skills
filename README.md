# skills

A [Claude Code](https://code.claude.com) plugin marketplace of small agent skills for product work — reviewing planning artifacts before they reach execution, and running better qualitative user research.

| Plugin | Skill | What it does |
|---|---|---|
| `product-critique` | `critique-spec` | Critiques a spec / design doc / PRD before implementation planning. Hunts gaps, verifies every factual claim against the codebase, returns findings as concrete proposed spec edits. |
| `product-critique` | `critique-implementation-plan` | Critiques an implementation plan before execution. Applies the "Executor Test" to every step, verifies anchors, returns findings as concrete proposed plan edits. |
| `qualitative-product-research` | `practicing-user-interviews` | Roleplays a realistic potential user of *your* app and coaches your interview questions toward specific past behaviour, in real time. |
| `qualitative-product-research` | `live-interview-copilot` | During a real interview, you paste each reply and it returns the single best next question — short and speakable out loud. |

Each plugin bundles the skills for one phase of product work: `product-critique` reviews the artifacts (critique the *what*, then the *how*); `qualitative-product-research` runs the discovery interviews.

> [!WARNING]
> **Experimental.** `product-critique` is `v0.1.0` and only lightly tested; `qualitative-product-research` is `v0.1.0`. Expect rough edges and breaking changes. Feedback and issues welcome.

## Install

Add the marketplace, then install whichever plugins you want:

```text
/plugin marketplace add lamesjaidler/skills
/plugin install product-critique@skills
/plugin install qualitative-product-research@skills
```

Skills auto-activate when relevant (e.g. you draft a spec or plan and ask for a review, or say "be a user I can interview"), or invoke them explicitly with the `Skill` tool.

## Update

```text
/plugin marketplace update skills
```

Pulls the latest version of every installed plugin from the marketplace.

## Uninstall

```text
/plugin uninstall product-critique@skills
/plugin uninstall qualitative-product-research@skills
```

## Try it locally (before it's pushed)

Point the marketplace at a local checkout instead of GitHub:

```text
/plugin marketplace add /absolute/path/to/skills
/plugin install product-critique@skills
```

## Repository layout

```
skills/                                  # repo root = the marketplace
├── .claude-plugin/marketplace.json      # lists the plugins below
├── product-critique/                    # plugin (2 skills)
│   ├── .claude-plugin/plugin.json
│   └── skills/
│       ├── critique-spec/SKILL.md
│       └── critique-implementation-plan/SKILL.md
├── qualitative-product-research/        # plugin (2 skills + shared resource)
│   ├── .claude-plugin/plugin.json
│   ├── interview-principles.md          # shared via ${CLAUDE_PLUGIN_ROOT}
│   └── skills/
│       ├── practicing-user-interviews/SKILL.md
│       └── live-interview-copilot/SKILL.md
├── scripts/
│   ├── validate-marketplace.sh          # manifest validator (run in CI)
│   ├── dev.sh                           # load a plugin live into a throwaway session
│   └── release.sh                       # validate, bump version, refresh the install
├── .github/workflows/validate.yml
├── CHANGELOG.md                         # per-plugin version history
└── CONTRIBUTING.md                      # repo layout + validator invariants
```

## Contributing

Contributions welcome — see [CONTRIBUTING.md](./CONTRIBUTING.md) for the repository layout and the two invariants the validator enforces.

## License

[MIT](./LICENSE)
