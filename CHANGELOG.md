# Changelog

All notable changes to the plugins in this marketplace are documented here. Each
plugin is versioned independently via its `plugin.json`; entries below are
grouped by plugin and release.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## product-critique

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

### [0.2.0] — 2026-08-07

Added `mapping-opportunities` (still **experimental**):

- `mapping-opportunities` skill: turns a product or business outcome into a
  structured opportunity space — triages the outcome, synthesises each
  interview separately before amalgamating, tags every node as evidenced or
  assumed, and writes a persistent, updatable map to
  `docs/discovery/<outcome-slug>-opportunity-map.md` in the project it runs
  in, falling back to showing the map inline and asking where to write it
  if no project root is evident.
- Refuses to rank or roadmap a hypothesis-only tree, and returns an interview
  plan targeting the weakest-evidence nodes instead.
- Shared `opportunity-principles.md` at the plugin root, consumed via
  `${CLAUDE_PLUGIN_ROOT}` — outcome triage, framing rules, anti-slop
  discipline, evidence tags, and the map file format.

### [0.1.0] — 2026-06-18

Added to the marketplace. **Experimental.**

- `practicing-user-interviews` skill: roleplays a realistic potential user of
  your app and coaches your interview questions toward specific past behaviour.
- `live-interview-copilot` skill: suggests the single best next question during
  a real, live interview.
- Shared `interview-principles.md` at the plugin root, consumed by both skills
  via `${CLAUDE_PLUGIN_ROOT}`.
