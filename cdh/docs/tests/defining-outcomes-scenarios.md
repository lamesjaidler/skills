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

Scenario 3 ran 2026-08-08 in `sandbox-task4/baseline-3/` (agent stated it deliberately avoided reading skill drafts/expected files; judged valid). Scenarios 1 and 2 required re-runs: the first attempts (in-repo sandboxes) read the SDD brief above their sandbox and were discarded as non-independent; a second attempt in a scratchpad sandbox still inherited the repo cwd, found the by-then-shipped SKILL.md, and followed it — also discarded. The records below are the third, genuinely blind runs (2026-08-08, scratchpad sandboxes `baseline-task4-s1b/` / `-s2b/`, explicit instruction not to read outside the sandbox; each agent used only Write/Bash inside it). Note: the blind runs are milder than the discarded contaminated runs predicted — the model spontaneously knows output-vs-outcome (S2's agent even cited Continuous Discovery Habits unprompted) — so the skill's load-bearing content is the write-gate, the tier ladder, the slug/lineage rules, and the section contract, not the bare "outputs aren't outcomes" insight.

### Scenario 1 — output creep: FAILED (partial — write-gate and escape hatch, not headline AP5)

Did NOT record the launch as the outcome: wrote a long "DRAFT" essay-file at `discovery/assistant/outcome.md` explaining the output-vs-outcome gap, listing 4 unvalidated candidate outcome hypotheses and open questions. Failures against the success criteria:

- Wrote the file anyway, without any human choosing/confirming — labelled "Status: DRAFT — not yet validated with stakeholders" as the license to write first.
- No business/product/traction tier explanation (only output vs outcome).
- Offered to undo the reframe on request, verbatim: "If the team actually wants this file to just restate the feature/date as given, say so and I'll simplify it."
- File is prose, no usable statement/metric structure.

Rationalization for writing before a decision, verbatim: "while still fully delivering the requested file."

### Scenario 2 — business metric: FAILED (partial — ARR headlined, write-gate)

Correctly identified ARR as a lagging business outcome, decomposed it into levers with candidate product outcomes per lever, and recommended not interviewing against raw ARR. Failures against the success criteria:

- Wrote `discovery/arr/outcome.md` anyway — H1 verbatim: "# Outcome: Grow ARR 20% This Year", section "The outcome as set by leadership" — the business number sits as the file's headline outcome and slug even while the body argues against it.
- No human pick awaited; rationalization verbatim: "This document is the trio's first pass at that translation. It is deliberately a working draft, not a commitment."
- Candidates parked as a menu inside the file rather than proposed for a decision.

### Scenario 3 — multiple + traction: FAILED (as expected)

Created three outcome files (`increase-search-usage.md`, `boost-nps.md`, `reduce-churn.md`) with zero pushback on running three outcomes at once. Partially better than expected: it reframed each goal as a measurable statement and flagged metric ambiguity (which churn, which NPS survey) — but:

- No challenge to three simultaneous outcomes; no "one durable outcome per trio"; no recommendation of one with human deciding.
- Search usage framed as "% of WAU using search ≥1×/week" — still a single-feature traction metric, not flagged as such.
- NPS and churn accepted as trio outcomes (both lagging, company-level).

Rationalizations, verbatim:
- "The task said 'outcome files' (plural), so I didn't bundle them into a single doc" — deference to the letter of the request.
- Pushing back on the count framed as out of scope: adding anything not asked for "would be gold-plating a 3-outcome request."

### Pattern summary

The common spontaneous failure across all three blind runs is **writing the file before any human decision** — the "it's only a draft" move — plus formalizing whatever framing the request carried (ARR as headline/slug, three parallel outcome files). The tier ladder is known only partially (output-vs-outcome yes; business/product/traction and the traction flag no). Guidance must make tier classification explicit, gate the write on an explicit human pick, and pin the slug/H1/statement to the chosen product outcome with the original goal as History lineage.

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

### Re-verification after baseline re-run (scenarios 1–2, sandboxes `with-skill-1b/` / `-2b/`)

After the S1/S2 baselines were re-run blind and the rationalization table was re-anchored to their verbatims, both scenarios were re-run with the updated skill. Both PASS all criteria again: correct tier classification out loud, 2–3 candidates with a recommendation, no file written pending the human's pick, lineage-in-History plan. Both runs explicitly cited the new table rows as counters — "writing now would be exactly the 'It's a working draft' or 'Leadership's number can headline the file' rationalizations the skill explicitly rejects" — and S2's run independently caught the `arr` slug problem from the red-flag list.

## REFACTOR

One refactor round, triggered by the baseline re-run rather than a GREEN failure: the rationalization table rows sourced from the discarded contaminated runs ("I complied with the instruction as given", "Leadership already set it", "The trio can refine it later") were replaced with counters to the blind runs' actual rationalizations — "It's a working draft, not a commitment", "Leadership's number can headline the file", "If they insist, I'll restate it as given". The "They asked for three outcome files" row is unchanged (its source, baseline 3, was valid). GREEN re-verified for scenarios 1–2 after the edit; both pass. All table rows now trace to spontaneous baseline verbatims.
