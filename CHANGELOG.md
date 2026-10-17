# Changelog

All notable changes to the plugins in this marketplace are documented here. Each
plugin is versioned independently via its `plugin.json`; entries below are
grouped by plugin and release.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## product-critique

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
