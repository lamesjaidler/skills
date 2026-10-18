# skills

A [Claude Code](https://code.claude.com) plugin marketplace of small agent skills for product work — drafting PRDs, prototyping and critiquing UIs, reviewing planning artifacts before they reach execution, and running better qualitative user research.

| Plugin | Skill | Problem it solves | How to use |
|---|---|---|---|
| `product-development` | `create-raw-prd` | A PRD written straight from a one-line idea is full of guesses and build details, and its gaps only show up later in review or build. | Ask to write a PRD for your idea (or invoke `create-raw-prd`). It grills you on the product in rounds and checks every PRD section can be written from your answers. Then it writes a product-only draft to `docs/prd/<slug>.md`. Needs `mattpocock-skills`, which installs as a dependency. |
| `product-development` | `critique-prd` | A PRD reaches the spec with gaps the spec writer has to fill by guessing, beliefs stated as facts, and build choices that tie the spec's hands. | After a PRD is drafted (by `create-raw-prd` or by hand), ask for a review (or invoke `critique-prd`). You get numbered, severity-tagged findings as proposed PRD edits; any product decision it needs comes back as an open question for you, not a rule it made up. You choose which to apply. |
| `product-development` | `apply-laws-of-ux` | UI reviews come back as vague opinion, and new screens get designed without the known rules of how people perceive, decide, and remember. | Ask for a Laws of UX critique of a screenshot, page, URL, or flow, or for a prototype of a new UI (or invoke `apply-laws-of-ux`). A critique gives numbered, severity-tagged findings, each tied to one law with a concrete change; you pick which to act on and whether to prototype first or edit the code. A prototype gives a few switchable variants, each taking a different trade-off between laws. Needs `mattpocock-skills`, which installs as a dependency. |
| `product-development` | `critique-spec` | Specs reach implementation planning with gaps the author can't see — anything a planner would otherwise have to invent — and they resurface as bugs downstream. | Draft a spec / design doc, then ask for a review (or invoke `critique-spec`). You get numbered, severity-tagged findings as concrete proposed spec edits; you choose which to apply. |
| `product-development` | `critique-implementation-plan` | Plans look ready to execute but hide steps that force whoever runs them to guess — wrong file, missing test, stale anchor. | After a plan is drafted, ask for a review (or invoke `critique-implementation-plan`). Same format: numbered findings as proposed plan edits, scoped with you before anything is applied. |
| `product-development` | `stop-and-think` | A design grows through follow-up tweaks until nobody checks whether it is still the best way to reach the goal. | Before building, ask "is this the best way?" or "are we over-engineering this?" (or invoke `stop-and-think`). It states the goal in one sentence, sketches the simplest design from scratch, and returns a verdict — Keep, Adjust or Rewrite — with up to 5 changes. It changes nothing until you pick. |
| `product-development` | `update-pr` | PR titles and descriptions get written for the author, so a reviewer or later reader can't tell what changed or why it matters. | Run `/product-development:update-pr <PR number or URL>`. It reads the PR and its diff, rewrites the title and body in short, plain sentences starting with a tl;dr, and saves them with `gh pr edit`. Every fact from the old body is kept. Manual-only: it never triggers on its own. Needs the `gh` CLI, signed in. |
| `qualitative-product-research` | `practicing-user-interviews` | You're about to interview real users, but untrained questions lean on opinions and hypotheticals that produce flattering, useless answers — and there's nowhere safe to practice. | Run it in your app's repo and say "be a user I can interview". It plays a persona grounded in the repo and coaches each question toward specific past behaviour, live. |
| `qualitative-product-research` | `live-interview-copilot` | Mid-interview, under time pressure, it's hard to pick the best next question — easy to ask double-barrelled or leading ones and waste the session. | Start it before a live call, give it the research goal, then paste each reply. You get one short, speakable next question back per turn. |

Each plugin bundles the skills for one area of product work: `product-development` drafts and critiques the PRD (the *what*), prototypes or critiques the UI, reviews the spec and plan (the *how*), steps back to check a design is the right approach, and rewrites PR descriptions; `qualitative-product-research` runs the discovery interviews.

> [!WARNING]
> **Experimental.** `product-development` is `v0.4.0` and `qualitative-product-research` is `v0.1.0`; both are only lightly tested. Expect rough edges and breaking changes. Feedback and issues welcome.

## Install

Add the marketplace, then install whichever plugins you want:

```text
/plugin marketplace add lamesjaidler/skills
/plugin install qualitative-product-research@skills
/plugin install product-development@skills
```

Skills auto-activate when relevant (e.g. you draft a spec or plan and ask for a review, or say "be a user I can interview"), or invoke them explicitly with the `Skill` tool.

## Update

```text
/plugin marketplace update skills
```

Pulls the latest version of every installed plugin from the marketplace.

Upgrading from `product-critique`? Its skills (`critique-spec`, `critique-implementation-plan`) now ship in `product-development`. Install `product-development@skills`, then uninstall `product-critique@skills`.

## Uninstall

```text
/plugin uninstall qualitative-product-research@skills
/plugin uninstall product-development@skills
```

## Try it locally (before it's pushed)

Point the marketplace at a local checkout instead of GitHub:

```text
/plugin marketplace add /absolute/path/to/skills
/plugin install product-development@skills
```

## Repository layout

```
skills/                                  # repo root = the marketplace
├── .claude-plugin/marketplace.json      # lists the plugins below
├── qualitative-product-research/        # plugin (2 skills + shared resource)
│   ├── .claude-plugin/plugin.json
│   ├── interview-principles.md          # shared via ${CLAUDE_PLUGIN_ROOT}
│   └── skills/
│       ├── practicing-user-interviews/SKILL.md
│       └── live-interview-copilot/SKILL.md
├── product-development/                 # plugin (7 skills; depends on mattpocock-skills)
│   ├── .claude-plugin/plugin.json
│   └── skills/
│       ├── create-raw-prd/SKILL.md
│       ├── critique-prd/SKILL.md
│       ├── critique-spec/SKILL.md
│       ├── critique-implementation-plan/SKILL.md
│       ├── stop-and-think/SKILL.md
│       ├── update-pr/SKILL.md
│       └── apply-laws-of-ux/
│           ├── SKILL.md
│           └── laws.md              # the 30 laws, grouped into seven lenses
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
