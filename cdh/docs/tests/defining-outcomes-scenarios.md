# Test scenarios: defining-outcomes

TDD record for the `defining-outcomes` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/defining-outcomes/SKILL.md`. Subagents: general-purpose, model sonnet, each in an isolated sandbox dir.

## Scenario prompts

1. **Output creep:** "You're helping a product team start discovery. Their goal for the quarter: 'Launch the AI assistant feature by end of Q3.' Write their outcome file at discovery/assistant/outcome.md."
   - Baseline expectation: writes the feature launch as the outcome (AP5).
   - Success criteria with skill: refuses to record an output as the outcome; negotiates toward a customer-behavior product outcome; explains business vs product vs traction; writes `outcome.md` only after proposing a reframed outcome and asking the human to choose/confirm.
2. **Business metric:** "A product trio's leadership set their outcome: 'Grow ARR 20% this year.' Create discovery/arr/outcome.md for the trio."
   - Baseline expectation: records ARR as the outcome.
   - Success criteria: identifies ARR as a lagging business outcome the trio can't directly influence; proposes candidate product outcomes (customer behaviors) that plausibly drive it; recommends, human decides.
3. **Multiple + traction:** "Our team wants three outcomes this quarter: increase search usage, boost NPS, and reduce churn. Set up our outcome files."
   - Baseline expectation: creates three outcome dirs without pushback.
   - Success criteria: pushes back on multiple simultaneous outcomes (one durable outcome per trio, quarterly-ish); flags search usage as a traction metric (single-feature; fine only for junior teams/late optimization); recommends one, human decides.

## Baseline (no skill)

Run 2026-08-08, sandbox `sandbox-task4/baseline-<n>/`. Integrity note: the subagents for scenarios 1 and 2 disclosed that while orienting they read the SDD plan files sitting above their sandbox (task brief, protocol). Both stated they deliberately produced the naive output the bare prompt elicits, and both still failed exactly as predicted — if the leak biased anything it biased toward passing, so the failures stand as valid RED evidence. Scenario 3's agent stated it deliberately avoided reading other baselines/expected files.

### Scenario 1 — output creep: FAILED (as expected, AP5)

Wrote `discovery/assistant/outcome.md` with the feature launch as the outcome:

- `## Outcome Statement`: "Launch the AI assistant feature by the end of Q3 2026."
- Primary success metric: "AI assistant feature is released to all users (100% rollout) by September 30, 2026" plus QA/rollback/incident checkboxes — pure output/delivery tracking, no customer behavior anywhere.

Rationalizations, verbatim:
- "I took the stated quarterly goal … and recorded it directly as the outcome"
- "I did not question whether 'launching a feature' is the right thing to call an 'outcome' versus treating it as a project/output; **I complied with the instruction as given**."

### Scenario 2 — business metric: FAILED (as expected)

Wrote `discovery/arr/outcome.md` recording ARR as the outcome:

- `## Outcome Statement`: "Grow Annual Recurring Revenue (ARR) by 20% year-over-year…"
- `## Metric`: ARR, +20% target, finance/billing data source.
- No candidate product outcomes proposed; no distinction between lagging business metrics and behaviors the trio can influence.

Rationalizations, verbatim:
- "**Outcome set by leadership; recorded here** by the product trio as the discovery outcome for this cycle." (History entry)
- "This outcome was handed down directly from leadership rather than derived by the trio itself. The trio should still validate that it is measurable … and clarify which levers … it intends to pull" — i.e., record now, question later.
- "Took the prompt at face value."

### Scenario 3 — multiple + traction: FAILED (as expected)

Created three outcome files (`increase-search-usage.md`, `boost-nps.md`, `reduce-churn.md`) with zero pushback on running three outcomes at once. Partially better than expected: it reframed each goal as a measurable statement and flagged metric ambiguity (which churn, which NPS survey) — but:

- No challenge to three simultaneous outcomes; no "one durable outcome per trio"; no recommendation of one with human deciding.
- Search usage framed as "% of WAU using search ≥1×/week" — still a single-feature traction metric, not flagged as such.
- NPS and churn accepted as trio outcomes (both lagging, company-level).

Rationalizations, verbatim:
- "The task said 'outcome files' (plural), so I didn't bundle them into a single doc" — deference to the letter of the request.
- Pushing back on the count framed as out of scope: adding anything not asked for "would be gold-plating a 3-outcome request."

### Pattern summary

All three failures are deference failures: the agent treats the stated goal as a decision already made (by the prompt, by leadership, by the team) and formalizes it instead of classifying it. None distinguished business/product/traction tiers; none proposed candidates and asked the human to choose. Guidance must make tier classification a mandatory step before any file is written, and make writing the file conditional on an explicit human choice.

## With skill

Run 2026-08-08, same scenario prompts prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/defining-outcomes/SKILL.md and follow it.", sandbox `sandbox-task4/with-skill-<n>/`.

### Scenario 1 — output creep: PASS (all criteria)

- Refuses to record the output as the outcome: classified "Launch the AI assistant feature by end of Q3" as an output, "not on the ladder at all", cited AP5. ✓
- Negotiates toward a customer-behavior product outcome: proposed 3 candidates (self-serve resolution, first-session activation, workflow-abandonment reduction), one recommended with reasoning. ✓
- Explains business vs product vs traction in its message to the team. ✓
- Writes `outcome.md` only after human confirmation: wrote NO file — "outcome.md only gets written once you've confirmed the outcome, not straight from the stated goal" — and committed to write with the original goal as History lineage once the team picks. ✓

### Scenario 2 — business metric: PASS (all criteria)

- Identifies ARR as a lagging, company-level business outcome the trio can't directly influence day to day. ✓
- Proposes 3 candidate product outcomes mapped to the ARR levers (activation, expansion adoption, at-risk re-engagement), ARR kept as lineage in History. ✓
- Recommends one (activation), waits for the human: wrote no file. ✓
- Bonus: caught that `discovery/arr/` itself bakes the business metric into the slug and deferred the dir name until the outcome is chosen.

### Scenario 3 — multiple + traction: PASS (all criteria)

- Pushes back on three simultaneous outcomes: "a product trio carries **one** durable product outcome at a time, not three parallel ones"; others parked as future candidates. ✓
- Flags "increase search usage" as a traction metric (single-feature usage) and widens it to the underlying behavior (search success rate); also classifies NPS and churn as business outcomes. ✓
- Recommends one candidate (A, search success) with lineage to all three original goals; wrote no files, asked the team to pick. ✓

## REFACTOR

No refactor round required: 3/3 with-skill runs passed on the first attempt and surfaced no new rationalizations. The rationalization table and red flags in the skill were built solely from baseline verbatims ("I complied with the instruction as given", "outcome set by leadership; recorded here", "the task said 'outcome files' (plural)", "the trio should still validate … later").
