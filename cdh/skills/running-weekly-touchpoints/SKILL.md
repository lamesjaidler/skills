---
name: running-weekly-touchpoints
description: Use when running the team's weekly discovery ritual or check-in, reviewing discovery health or staleness, deciding what to do after an assumption test result, checking whether the outcome metric moved, or preparing to walk stakeholders through discovery work.
---

# Running Weekly Touchpoints

## Overview

You keep the trio's weekly discovery ritual — user-invoked only; never set up automation, cron, or hooks. Read all of `discovery/` (paths: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`); the ritual ends by writing `touchpoints/YYYY-MM-DD.md` (today's date). A standalone stakeholder update runs step 4. Anti-patterns cited (AP3, AP10, AP11): `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

All discovery loops run concurrently, never as phases — a failed test can send the team to any level of the tree.

## 1. Staleness scan

Report with dates and counts:

- Days since the newest snapshot in `discovery/snapshots/` — weekly cadence; over 7 days is slipping.
- Branches in `ost.md` with no `[evidence: …]` tag, or no recent one — starving branches.
- Solutions at `(status: testing)` whose spec's Result is missing or unfilled — chase the number and record it via `testing-assumptions`.
- Weeks since a metric value was last recorded in `outcome.md` `## History`.

## 2. Measurement

Ask the human, every ritual: "Did the product outcome move? Did the business outcome follow?" (`outcome.md` `## Metric` defines it). Log given numbers here, and append them to `outcome.md` `## History`; no answer this run → log the open question, never a guessed number.

## 3. Cycle decisions

For each pending or missed test result, present the moves compare-and-contrast — never "should we kill it?" (AP10) — each named to the tree node it revisits:

| Move | Revisits | Via |
|---|---|---|
| Stronger test, same assumption | that assumption's spec in `assumptions/<solution-slug>.md` | testing-assumptions |
| Prune the solution; the rest keep testing in parallel | that solution's line — `(status: pruned)` | testing-assumptions |
| Revisit the target opportunity | the `<- TARGET` node | prioritizing-opportunities |
| Harvest new evidence | snapshots and the opportunity branch | continuous-interviewing, mapping-the-opportunity-space |

Pruning below 3 candidates gets flagged — route to `ideating-solutions` to restore 3; survivors are never tested one at a time (AP3). Recommend one move with reasoning; the human decides. No answer in this run → log the recommendation and a pending decision; `ost.md` statuses change only after the human decides. Margin shapes the recommendation, never who chooses; iterating needs no broken instrument — bigger-and-stronger is standard.

## 4. Stakeholder prep (on request)

Show the tree and the trail, not conclusions alone (AP11). In order: the outcome and its numbers (baseline → latest → target); the tree's shape — the target *and its siblings*; each claim's evidence (snapshot quotes and tags); each test's pre-set criterion and raw result ("2 of 8 against at least 4 of 8"); each decision point with the alternatives compared and who decided. A bare verdict ("pruned") always travels with the comparison that produced it.

## 5. Write the log

`discovery/<outcome-slug>/touchpoints/YYYY-MM-DD.md`:

```markdown
# Touchpoint: YYYY-MM-DD

## Staleness
## Measurement
## Decisions
```

**Done when** the file is on disk with every staleness item, the measurement answer (or open question), and every decision — made or pending — captured. A quiet week still writes its log: recording what was observed, asked, and decided is the ritual's product, not invented data.

## Rationalizations

| Excuse | Reality |
|---|---|
| "No files needed changes, so nothing to write" | The log IS the deliverable — written every ritual. |
| "Metric refresh can wait for a monthly checkpoint" | Step 2 is weekly. Ask; log the answer or its absence. |
| "The miss was decisive — record the prune" | You recommend; the human decides; the log records which. |
| "Promote the strongest survivor to testing next" | Remaining candidates run in parallel; below 3, flag and route to ideation. |
