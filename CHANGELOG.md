# Changelog

All notable changes to the plugins in this marketplace are documented here. Each
plugin is versioned independently via its `plugin.json`; entries below are
grouped by plugin and release.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## product-critique

### Retired — 2026-10-18

- Plugin removed from the marketplace. `critique-spec` and
  `critique-implementation-plan` moved unchanged to `product-development`
  0.3.0. Install `product-development@skills`, then uninstall
  `product-critique@skills`.

### [0.1.1] — 2026-10-17

- `critique-spec` trigger narrowed to specs and design docs. PRDs now go to
  `critique-prd` in `product-development`, so the two skills no longer compete
  for the same requests.

### [0.1.0] — 2026-06-19

`critique-spec` refinements (still **experimental**):

- Added pass-mode guidance — when to run a single critique vs. fan out across
  diverse perspectives, with criteria for each.
- Expanded lifecycle checks: concurrency implications and a cross-check against
  deploy topology for gaps.
- Added internal-reference checks to the critique guidelines.

### [0.0.0] — 2026-06-18

Initial release. **Experimental** — both skills only lightly tested; expect
rough edges and breaking changes.

- `critique-spec` skill: critiques a spec / design doc / PRD before
  implementation planning, returning findings as concrete proposed spec edits.
- `critique-implementation-plan` skill: critiques an implementation plan before
  execution, returning findings as concrete proposed plan edits.

## qualitative-product-research

### [0.1.0] — 2026-06-18

Added to the marketplace. **Experimental.**

- `practicing-user-interviews` skill: roleplays a realistic potential user of
  your app and coaches your interview questions toward specific past behaviour.
- `live-interview-copilot` skill: suggests the single best next question during
  a real, live interview.
- Shared `interview-principles.md` at the plugin root, consumed by both skills
  via `${CLAUDE_PLUGIN_ROOT}`.

## product-development

### [0.9.0] — 2026-10-19

- `create-spec`: the hand-off now starts with a summary of the finished spec.
  A fresh subagent, which never saw the brainstorming, runs `summarise` on the
  spec file, so you see its decisions and open items before you approve it.
- `summarise`: a summary of a PRD, spec or plan no longer ends by pointing to
  a `critique-*` skill. A summary of carried-out work still ends by pointing
  to `mattpocock-skills:code-review`.

### [0.8.1] — 2026-10-19

- `summarise`: the argument hint now mentions a plan already carried out,
  not only a PRD, spec or plan.

### [0.8.0] — 2026-10-19

- `create-spec` skill: one command from a PRD to a finalised spec. You
  brainstorm the spec with `superpowers:brainstorming`, which starts from the
  PRD and asks only how it gets built. Then fresh subagents, which never saw
  the brainstorming, run `stop-and-think` on it, build three UI prototypes
  with `apply-laws-of-ux` for you to pick or mix (only if the spec has a UI),
  and run `critique-spec` against the PRD. Changes are applied for you; you're
  asked only when one undoes a decision you made while brainstorming or needs
  a product call. The chosen prototype is linked from the spec. The PRD is
  never edited: decisions that contradict it are listed in the hand-off for
  you to update. The hand-off points you to `/build-from-spec` next. You have
  to start it yourself (`/create-spec`); it never fires on its own.

### [0.7.0] — 2026-10-19

- `summarise` skill: summarises a PRD, spec or implementation plan for the
  person about to approve it. The reply lists what the doc decided and what it
  leaves open for them, each item with a pointer to its section or ID. It is
  written in ASD-STE100 Simplified Technical English (the writing rules in our
  own words, no dictionary). It is not a review: it ends by pointing to the
  matching `critique-*` skill. After an agent has carried out a plan, it
  summarises the work instead, from the branch's commits and diff: what was
  done, what changed from the plan, what was not done, and what still needs
  the user. It runs only read-only git commands.

### [0.6.0] — 2026-10-18

- `build-from-spec` skill: one command from a spec to an open PR. Fresh
  subagents write the plan with `superpowers:writing-plans` and critique it
  against the spec with `critique-implementation-plan`, applying the fixes;
  you answer only the decisions they need. It then implements the plan with
  `superpowers:subagent-driven-development`, runs `/simplify` and
  `/security-review` in fresh subagents that fix what they find, pushes the
  branch, opens a PR into `main` and rewrites it with `update-pr`. Expects the
  spec on its own branch or worktree. Manual-only: it never triggers on its
  own.
- `update-pr` is no longer manual-only, so `build-from-spec` can call it.
  You can still run it yourself with `/product-development:update-pr`.
- New dependency: `superpowers` from `claude-plugins-official`.

### [0.5.0] — 2026-10-18

- `stop-and-think` skill: steps back from a design, spec or plan and checks
  it against the goal, not against its earlier versions. It sketches the
  simplest design from scratch, then returns a Keep / Adjust / Rewrite verdict
  with up to 5 changes. It changes nothing until the user picks.
- `update-pr` skill: rewrites a GitHub PR's title and description so a reader
  with no context understands them, starting with a tl;dr in ASD-STE100
  Simplified Technical English. It keeps every fact from the old body and
  saves the result with `gh pr edit`. Manual-only: it never triggers on its
  own.
- Both skills copied unchanged from personal skills in `~/.claude/skills`.

### [0.4.0] — 2026-10-18

- `create-prd` skill: one command for the whole PRD flow. It runs
  `create-raw-prd` with you, then hands the draft to a fresh subagent that
  runs `critique-prd` without seeing the grilling, so the critique isn't
  biased by the drafting. It then runs `critique-prd`'s fix flow with you. You
  have to start it yourself (`/create-prd`); it never fires on its own, so "write a PRD"
  still goes to `create-raw-prd`.

### [0.3.0] — 2026-10-18

- `critique-spec` and `critique-implementation-plan` skills moved here,
  unchanged, from the retired `product-critique` plugin. One plugin now covers
  the PRD, UI, spec and plan.

### [0.2.0] — 2026-10-18

- `apply-laws-of-ux` skill: critiques an existing UI (screenshot, code, live URL, or
  description) against the 30 Laws of UX from lawsofux.com, or prototypes a new
  one. A critique returns numbered, severity-tagged findings, one law each,
  with a concrete change. It then asks which findings to act on and whether to
  prototype first or edit the code directly. Prototypes run through
  `mattpocock-skills:prototype`: each variant takes a different trade-off
  between laws and names the law behind each design choice. The laws live in
  `laws.md` next to the skill, grouped into seven lenses.

### [0.1.0] — 2026-10-17

- `critique-prd` skill: reviews a PRD before the spec is written and returns
  numbered, severity-tagged findings as proposed PRD edits. It keeps the PRD
  product-only (build details are removed and parked for the spec) and
  traceable (unchecked beliefs become `A` items; missing product decisions
  become `Q` items with a recommended answer). After fixes are applied it sets
  the status line to `critiqued · <date>`. Resolves `create-raw-prd`'s
  hand-off pointer.

### [0.0.0] — 2026-10-17

Added to the marketplace. **Experimental.**

- `create-raw-prd` skill: grills you on a product idea (via
  `mattpocock-skills:grilling`), checks that every PRD section can be written
  from your answers, then writes a product-only raw PRD to
  `docs/prd/<slug>.md`, ready for critique.
- Depends on the `mattpocock-skills` plugin from `claude-plugins-official`. The
  root `marketplace.json` now allowlists that marketplace for cross-marketplace
  dependencies.
