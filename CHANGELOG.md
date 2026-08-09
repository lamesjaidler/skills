# Changelog

All notable changes to the plugins in this marketplace are documented here. Each
plugin is versioned independently via its `plugin.json`; entries below are
grouped by plugin and release.

The format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## continuous-discovery

### [0.0.0] — 2026-08-09

Initial release. **Experimental** — expect rough edges and breaking changes.

Continuous Discovery Habits (Teresa Torres) as agent skills:

- `defining-outcomes`: negotiate and define a product outcome to anchor discovery.
- `continuous-interviewing`: run weekly customer interviews that surface real
  stories and opportunities.
- `mapping-the-opportunity-space`: build and maintain an opportunity solution
  tree from interview evidence.
- `prioritizing-opportunities`: assess and select a target opportunity.
- `ideating-solutions`: generate and compare multiple solutions for the target
  opportunity.
- `testing-assumptions`: identify, map, and test the riskiest assumptions behind
  candidate solutions.
- `running-weekly-touchpoints`: the weekly discovery ritual tying the habits
  together.
- Shared plugin-root resources (`discovery-layout.md`, `anti-patterns.md`,
  `templates/`) consumed by the skills via `${CLAUDE_PLUGIN_ROOT}`.

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

### [0.1.0] — 2026-06-18

Added to the marketplace. **Experimental.**

- `practicing-user-interviews` skill: roleplays a realistic potential user of
  your app and coaches your interview questions toward specific past behaviour.
- `live-interview-copilot` skill: suggests the single best next question during
  a real, live interview.
- Shared `interview-principles.md` at the plugin root, consumed by both skills
  via `${CLAUDE_PLUGIN_ROOT}`.
