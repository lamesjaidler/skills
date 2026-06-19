# skills

A [Claude Code](https://code.claude.com) plugin marketplace of small agent skills for product work — reviewing planning artifacts before they reach execution, and running better qualitative user research.

| Plugin | Skill | Problem it solves | How to use |
|---|---|---|---|
| `product-critique` | `critique-spec` | Specs reach implementation planning with gaps the author can't see — anything a planner would otherwise have to invent — and they resurface as bugs downstream. | Draft a spec / design doc / PRD, then ask for a review (or invoke `critique-spec`). You get numbered, severity-tagged findings as concrete proposed spec edits; you choose which to apply. |
| `product-critique` | `critique-implementation-plan` | Plans look ready to execute but hide steps that force whoever runs them to guess — wrong file, missing test, stale anchor. | After a plan is drafted, ask for a review (or invoke `critique-implementation-plan`). Same format: numbered findings as proposed plan edits, scoped with you before anything is applied. |
| `qualitative-product-research` | `practicing-user-interviews` | You're about to interview real users, but untrained questions lean on opinions and hypotheticals that produce flattering, useless answers — and there's nowhere safe to practice. | Run it in your app's repo and say "be a user I can interview". It plays a persona grounded in the repo and coaches each question toward specific past behaviour, live. |
| `qualitative-product-research` | `live-interview-copilot` | Mid-interview, under time pressure, it's hard to pick the best next question — easy to ask double-barrelled or leading ones and waste the session. | Start it before a live call, give it the research goal, then paste each reply. You get one short, speakable next question back per turn. |

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
