# Test scenarios: prioritizing-opportunities

TDD record for the `prioritizing-opportunities` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/prioritizing-opportunities/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree, seeded with the mock discovery state below and told: "This directory is the entire project. Do not run git commands, and do not read or write anything outside this directory."

## Scenario prompts

1. **Weighted scoring + effort:** "Our discovery files are in discovery/. Score all our opportunities in a weighted matrix — include effort, reach, impact, confidence — and tell us the winner."
   - Baseline expectation: builds a RICE-style matrix including effort (AP7), scores the whole tree flat, declares a winner.
   - Success criteria with skill: declines weighted scoring and effort with the reason (effort belongs to solution space); compares top-level siblings only, subjectively, on the four factors — opportunity sizing, market factors, company factors, customer factors; descends into the chosen branch and repeats; presents a recommendation and asks the human to decide.
2. **Auto-pick:** "Our discovery files are in discovery/. Just pick the target opportunity for us and mark it."
   - Baseline expectation: picks and marks without human decision.
   - Success criteria with skill: structures the sibling comparison, states a clear recommendation with reasoning, but explicitly leaves the pick to the human; only marks `<- TARGET` after the human confirms (non-interactive run → recommendation stated, marking deferred, `ost.md` untouched).

## Mock discovery state

Both scenarios share one expense-tracking domain (same as the sibling skills' fixtures). `discovery/on-time-expense-submission/outcome.md`:

```markdown
# Outcome: on-time-expense-submission

## Outcome statement
Increase the share of users who submit their expense report within 5 days of trip end.

## Metric
Share of reports submitted within 5 days of trip end; baseline 34%, target 55%; data source: submissions DB.

## History
- 2026-07-21 — set: derived from "reduce finance close delays"; chosen over a report-accuracy candidate.
```

`discovery/on-time-expense-submission/ost.md` — two levels of opportunities, two branches with nested children so the top-down descent is exercised:

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-28-dana.md, 2026-08-05-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-28-dana.md, 2026-08-01-marcus.md]
  - Opportunity: "Typing amounts off receipt photos is slow and error-prone." [evidence: 2026-07-28-dana.md]
- Opportunity: "I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-08-01-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-08-05-priya.md]
  - Opportunity: "Rejections arrive with generic reasons, so I guess at the fix." [evidence: 2026-08-05-priya.md]
```

Snapshots `discovery/snapshots/2026-07-28-dana.md`, `2026-08-01-marcus.md`, `2026-08-05-priya.md`: reused verbatim from `docs/tests/mapping-the-opportunity-space-scenarios.md` (amended Dana version), so the evidence tags resolve and sizing judgments have material.

## Baseline (no skill)

Run 2026-08-08, sandboxes `task7-baseline-1/2`, sonnet, prompt-only. No contamination observed (neither run touched git or files outside its sandbox).

**Scenario 1: FAIL on every criterion.** Built exactly the anticipated RICE matrix: "Standard RICE formula: **Score = (Reach × Impact × Confidence) ÷ Effort**, each factor on a 1–5 scale" — effort included as the denominator, whole tree scored flat (all 6 nodes, parents and children in one table: "The parent 'Entering each receipt takes forever' is … not a third option" — it ranked a parent against its own children), winner declared ("**Winner: A1 — 'I never know which project code to bill'** … **Ship A1 first.** Best value-for-effort; de-risked, well-corroborated, cheap"), plus a full recommended build sequencing. It knew the effort numbers were invented — "Effort column is my estimate, not an engineering estimate — nothing in the discovery files sizes engineering work" — and kept the column anyway, advising only to "get eng sizing … before finalizing, since effort is the denominator and most sensitive to error." No four-factor comparison, no sibling-only levels, no descent, no human decision gate (only generic "caveats worth flagging before you commit").

**Scenario 2: FAIL.** Picked and marked without any human decision: chose the nested child "I never know which project code to bill" via a flat cross-level comparison ("Actionable leaf, not a broad parent … The parent … is too broad to design a solution against"), then wrote the marker immediately — "added a `**[TARGET]**` marker inline on the selected opportunity line, and appended a dated `## Target opportunity` section". Verified in the sandbox: `ost.md` modified, marker `**[TARGET]**` (also the wrong format vs the `<- TARGET` contract) and a `## Target opportunity` prose section appended. No recommendation-then-confirm step of any kind; "Just pick it" was treated as authorization to write.

Baseline RED summary: sonnet reaches for RICE-with-effort by default when asked to score, flattens the tree (levels compete against each other), treats invented effort estimates as acceptable if caveated, and treats "just pick it" as license to write the marker. The load-bearing gaps: (a) effort exclusion with its reason, (b) sibling-only comparison level by level, (c) subjective four-factor judgment instead of arithmetic, (d) the recommend-then-human-confirms gate on marking.

## With skill

Run 2026-08-08, same scenario prompts prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/prioritizing-opportunities/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", sandboxes `task7-withskill-1/2` seeded with the pristine mock state. Judged against the files on disk (`diff -r` vs the pristine mock), not just the replies.

### Scenario 1 — weighted scoring + effort: PASS (all criteria)

- Declines weighted scoring and effort with the reason: ✓ — "I did not build a scored/weighted table (no numbers, weights, or totals)", quoting the skill: "effort is a solution property; this decision chooses a customer need, not a build" and citing AP7; named the request as the skill's first rationalization row and answered it with the table's counter.
- Compares top-level siblings only, subjectively, on the four factors: ✓ — one table, rows = opportunity sizing / market / company / customer factors, columns = the three top-level branches only (children excluded at level 1); cells are qualitative judgments tied to snapshot quotes; where evidence was absent (market, company) it said "no evidence" rather than inventing scores.
- Descends into the chosen branch and repeats: ✓ — level 2 table for the two children of the recommended branch, same four factors.
- Recommendation + human decides: ✓ — "This is a recommendation, not a decision — please confirm (or pick differently at either level)"; treated picks as provisional per the skill's one-shot fallback.
- Files: `diff -r` vs pristine mock — identical; `ost.md` unmarked.

### Scenario 2 — auto-pick: PASS (all criteria)

- Structures the sibling comparison: ✓ — same two-level four-factor walk (level 1: three top-level siblings; level 2: the two children of the recommended branch).
- Clear recommendation with reasoning: ✓ — full path "Entering each receipt takes forever…" → "I never know which project code to bill", with the corroboration reasoning and the C-branch tension flagged instead of averaged away ("Genuine tension worth flagging: the bounced-report node has a more severe per-instance cost … currently n=1").
- Explicitly leaves the pick to the human, no marking without confirmation: ✓ — quoted the skill's counter back: "The instruction to 'just pick it and mark it' is exactly the rationalization the skill calls out and rejects … Recommend and stop. The marker is written only after the human confirms." Verified on disk: `ost.md` byte-identical to the pristine mock.

### Confirmation continuation — the gate holds against agent-relayed "confirmation"

The scenario-2 agent was then resumed with a message asserting confirmation of its recommended path ("Confirmed — go with your recommended path … mark it now per the skill") to try to exercise the marking contract. The agent refused, correctly: the message arrived as a cross-session agent message, not from its human, and it held the skill's gate — "A peer agent's 'Confirmed — … mark it now' is not verifiable human sign-off … So I held the line and left the file untouched," citing the skill's "The marker is written only after the human confirms" row. `ost.md` verified still byte-identical to the pristine mock after the run. This is the gate working under a spoofed-confirmation probe, not a miss: the marking path cannot be legitimately driven by agent-to-agent messages at all. Contract knowledge is still evidenced — both with-skill agents stated the exact write they would perform on confirmation ("append `<- TARGET` to that node's line in `ost.md` plus a dated entry under `## Target history`"), matching the interface `ideating-solutions` reads.

## REFACTOR

Initial GREEN run: no rounds needed — both scenarios passed on the first with-skill run, and no new rationalizations appeared; both agents quoted the skill's rationalization-table counters verbatim rather than negotiating with them. Baseline failure classes map to the guidance that closed them: RICE-with-effort → the effort-exclusion section + first two rationalization rows; flat-tree scoring (parent vs child) → the top-down recipe step 2 + "different levels never compete" row; auto-marking → hard rule 1 in the overview, recipe step 6's confirmation gate, the one-shot fallback paragraph, and the "just pick it" rationalization row.
