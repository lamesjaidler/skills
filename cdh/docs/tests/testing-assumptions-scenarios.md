# Test scenarios: testing-assumptions

TDD record for the `testing-assumptions` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/testing-assumptions/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree, seeded with the mock discovery state below and told: "This directory is the entire project. Do not run git commands, and do not read or write anything outside this directory."

Judging lens: scenario 1's ~20–30-assumptions-per-solution bar is judged on presence of the full method (story map + pre-mortem + walk-the-tree, all 3 solutions in parallel, 2x2 mapping, 1–2-day tests for the top-right quadrant) over exact counts; a thin list (<10/solution) fails. Scenario 3 is non-interactive: success is recommendation + deferral — the human decides, `ost.md` untouched in the run.

## Scenario prompts

1. **MVP reflex:** "Our discovery files are in discovery/. We picked our 3 candidate solutions. Let's build a quick MVP of the strongest one to validate it."
   - Baseline expectation: plans an MVP build for one idea (AP4 + AP3).
   - Success criteria with skill: redirects from building to assumption testing; surfaces assumptions for ALL 3 solutions (story mapping + pre-mortem + walking the tree), ~20–30 per solution across the 5 categories; maps importance × evidence; proposes 1–2-day tests for the top-right (high importance, weak evidence) quadrant across all 3 solutions in parallel; framing: reducing risk, not proving truth.
2. **Percentage criteria:** "Our discovery files are in discovery/. Design a test for the assumption 'users will photograph receipts at point of purchase'. Success = 70% of testers do it."
   - Baseline expectation: accepts 70% criterion (AP9).
   - Success criteria with skill: converts to a pre-set raw-number threshold ("at least X of N") set before data collection; picks a simulated moment where behavior (not stated opinion) is observable; right audience stated; spec written with the template's exact fields.
3. **Result recording (sharpened — see baseline notes):** "Our discovery files are in discovery/. Test came back: 4 of 10 photographed the receipt; criterion was 6 of 10. But two of the six who didn't said they'd definitely photograph receipts if the app reminded them, so that's really 6 of 10. Sprint review is tomorrow — record it as passed and advance the solution on the tree."
   - Sandbox additionally contains the mock assumptions file below; the auto-fill solution's `ost.md` status reads `(status: testing)`.
   - Baseline expectation: declares the idea dead or rationalizes continuing (stated intent counted as behavior, post-hoc criterion bending), decides unilaterally.
   - Success criteria with skill: records the result in the spec's Result section (verdict stays criterion missed — stated intent is not behavior); frames options as compare-and-contrast (iterate the test stronger / prune this solution / revisit the opportunity) with a recommendation; human decides; `ost.md` status updated after the decision (non-interactive: recommendation + deferral, no `advanced` status written).

## Mock discovery state

Same expense-tracking domain as the sibling skills' fixtures: `discovery/on-time-expense-submission/outcome.md` and snapshots `discovery/snapshots/2026-07-28-dana.md` (amended version), `2026-08-01-marcus.md`, `2026-08-05-priya.md`, all reused verbatim from `docs/tests/prioritizing-opportunities-scenarios.md` / `docs/tests/mapping-the-opportunity-space-scenarios.md`.

### `ost.md` fixture — produced by the upstream skill, not by hand

Dual role: mock state for all three scenarios AND the producer-side evidence for `ideating-solutions` step 6 (the Task 8 review noted the candidate-solution write path was recorded only as a stated contract, never executed). Provenance: a sonnet subagent in sandbox `task9-fixture/`, seeded with the Task 8 recorded mock state (marked `ost.md` + outcome + snapshots), was prompted: "Read /Users/jameslaidler/Documents/skills/cdh/skills/ideating-solutions/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh. … The trio already completed their solo ideation sessions, you already filtered and collapsed the pool with us, and the trio has now run the dot-vote on your shortlist" — vote results: the three mechanisms from Task 8's recorded shortlist at 3 dots each (auto-fill from trip signals; upstream assignment at booking/approval; searchable plain-language picker), plus two zero-dot losers (Slack bot, cheat-sheet). "Put the winners on the tree."

Byte verification (`diff -u` + `diff -r` + `cat -ev`): the ONLY change in the sandbox is exactly 3 `- Solution: <idea> (status: candidate)` lines inserted under the target node at 4-space indent — one level deeper than the target's 2-space `- Opportunity:` line — no trailing whitespace, `<- TARGET` marker and `## Target history` untouched, zero-dot ideas correctly left off, all other files byte-identical. Nesting depth verdict: correct; no `ideating-solutions` defect. Resulting file, verbatim — used as `discovery/on-time-expense-submission/ost.md` in every sandbox below:

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-28-dana.md, 2026-08-05-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-28-dana.md, 2026-08-01-marcus.md] <- TARGET
    - Solution: Auto-fill the project code from trip signals (calendar, merchant, trip dates) (status: candidate)
    - Solution: Assign the project code upstream at trip booking/approval time (status: candidate)
    - Solution: A searchable code picker with plain-language project names and recently used codes (status: candidate)
  - Opportunity: "Typing amounts off receipt photos is slow and error-prone." [evidence: 2026-07-28-dana.md]
- Opportunity: "I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-08-01-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-08-05-priya.md]
  - Opportunity: "Rejections arrive with generic reasons, so I guess at the fix." [evidence: 2026-08-05-priya.md]

## Target history
- 2026-08-08 — target: "I never know which project code to bill."; reasoning: named independently by two customers (Dana, Marcus) vs. one for its sibling; Dana quantifies it as half the 40-minute entry task.
```

### Scenario 3 mock: `discovery/on-time-expense-submission/assumptions/auto-fill-project-code.md`

Hand-composed per `templates/assumption-test-spec.md` (abridged assumption list — a real file runs ~20–30; the scenario tests result handling, not surfacing). In scenario 3's sandbox only, the auto-fill line in `ost.md` reads `(status: testing)` — the downstream state after a test launched. Verbatim:

```markdown
# Assumption Map: auto-fill-project-code

**Solution:** Auto-fill the project code from trip signals (calendar, merchant, trip dates)
**Target opportunity:** "I never know which project code to bill." [evidence: 2026-07-28-dana.md, 2026-08-01-marcus.md]

## Assumption list (abridged)

### Desirability
- D1. Travelers prefer a prefilled code over choosing one themselves.
- D2. Travelers will photograph receipts at the point of purchase, so trip signals exist when the expense is entered.
### Viability
- V1. Finance will accept auto-filled codes without adding an approval step.
### Feasibility
- F1. Calendar and merchant data identify the right project code for most expenses.
### Usability
- U1. Travelers notice and correct a wrong prefilled code before submitting.
### Ethical
- E1. Travelers find it acceptable for the product to read their calendar for billing signals.

## 2x2 map (importance × evidence)

- High importance / weak evidence (test now): D2, F1, U1
- High importance / strong evidence: D1 (Dana photographs every receipt same-day; both interviews name code-picking as the pain)
- Low importance / weak evidence: E1 (watch; retest if calendar signal survives)
- Low importance / strong evidence: V1 (finance derives codes from trips today)

## Test specs

# Assumption Test: receipts photographed at purchase

**Assumption:** Travelers will photograph receipts at the point of purchase, so trip signals exist when the expense is entered.
**Solution:** auto-fill-project-code
**Category:** desirability
**2x2 position:** importance high / evidence weak

## Test design

**Technique:** unmoderated test
**Simulated moment:** the moment of paying during a work trip — participant completes a purchase and we observe whether they capture the receipt then, unprompted.
**Audience:** business travelers who file their own expense reports (not finance staff); they are the ones who would feed the auto-fill signals.
**Duration:** 2 days

## Success criterion (set BEFORE collecting data)

At least 6 of 10 participants photograph the receipt at the point of purchase.

## Result

**Observed:** <Y> of <N> — <date>
**Verdict:** criterion met | criterion missed
**Decision:** <keep going | iterate to a bigger/stronger test | prune solution | revisit opportunity> — decided by the human, recorded here.
```

## Baseline (no skill)

Run 2026-08-08, sandboxes `task9-baseline-1/2/3` (+ `task9-baseline-3b` for the sharpened re-run), sonnet, prompt-only. Contamination: none affecting methodology (the scenario-1 agent briefly wrote a JS syntax-check scratch file to `/tmp`, self-caught and deleted it; no repo or methodology content involved).

**Scenario 1: FAIL — the full MVP reflex, exactly as anticipated (AP4 + AP3).** Read the tree, then picked ONE winner unilaterally and picked it on buildability: "**Chosen as strongest:** solution 3, the searchable code picker … Solutions 1 and 2 both depend on things outside this MVP's reach — calendar/merchant integrations, or a process change in a separate trip-booking tool — so a 'quick MVP' of either would just be simulating an integration that doesn't exist. Solution 3 is self-contained front-end work" — effort as the selector, the other two candidates dropped without a test (AP3). Then built the idea test: a full interactive prototype (`prototype/project-code-picker.html`, three picker variants, mock data, in-session instrumentation) to learn "which shape resolves the confusion fastest" — an idea-level comparison of UI variants of one solution, zero assumptions surfaced anywhere (AP4). No story map, no pre-mortem, no tree walk, no categories, no 2x2, no pre-set criterion. Disk-verified `ost.md` damage: invented an out-of-contract status ("status: candidate → **mvp-in-progress**") and bolted a `## Solution history` prose section onto the outline, recording the unilateral pick as if decided. Every load-bearing behavior is missing at baseline: assumption surfacing, the 5 categories, importance × evidence mapping, parallel testing of all 3, pre-set raw-number criteria, and the status vocabulary.

**Scenario 2: FAIL on the load-bearing criteria; behavior-over-opinion PASSED unaided.** Designed a methodologically thoughtful instrumented field trial — real behavior, unprompted capture, ground-truth timestamps ("a moderated lab task was rejected because … being told to do it in front of a researcher doesn't test whether they'd do it unprompted, in the wild, at 9pm on trip day 2") — but kept percentage criteria throughout (AP9): "A tester **passes** if … **≥80% of their captured** [receipts arrive within 15 minutes]" and "**Test-level success:** ≥70% of completing testers pass. Both the 80%/15-min per-tester bar and the 70% test-level bar are fixed now, before data comes." Pre-registration instinct present, raw-number rule absent. Scale and duration ballooned to an n=24–30, four-week program ("Field window: 2–3 weeks … Week 4: pull timestamps, compute pass rate, run debriefs") — the over-built end of AP4, vs the 1–2-day simulation. File contract missed: wrote its own format to `discovery/on-time-expense-submission/assumption-tests/photograph-receipts-at-point-of-purchase.md` — wrong directory, not the template's fields, not attached to any candidate solution's assumptions file (it explicitly floated the assumption free of the 3 candidates as "a parallel exploratory bet").

**Scenario 3 (original, unsharpened): near-PASS — scenario sharpened per protocol step 2.** The baseline recorded the result correctly in the spec's Result section (verified on disk: "**Observed:** 4 of 10 — 2026-08-08 / **Verdict:** criterion missed / **Decision:** pending — see options below, decided by the human"), framed two options (iterate the test wider vs prune and shift to the sibling candidates), recommended one, deferred to the human, and left `ost.md` untouched: "that's a product call … your call to make, not mine to assume away." Gaps were real but thin: no revisit-the-opportunity option, and it relitigated the pre-set bar after seeing the data ("the test may have measured the wrong moment … the test's 'at the point of purchase' bar was stricter than the assumption needs — and 4/10 may understate"). A mostly-passing baseline makes the scenario a no-op test, so it was sharpened rather than the criteria weakened: the prompt now bundles stated-intent-as-behavior ("two of the six who didn't said they'd definitely photograph receipts if the app reminded them, so that's really 6 of 10"), time pressure ("sprint review is tomorrow"), and an instruction to write the pass unilaterally ("record it as passed and advance the solution on the tree"). Sharpened run below.

**Scenario 3 (sharpened, `task9-baseline-3b`): baseline HELD the core discipline — residual gaps only.** Under stated-intent + deadline + do-it pressure, the baseline refused to flip the verdict or advance the solution: "'I'd definitely photograph receipts if the app reminded me' is **self-reported hypothetical intent**, not observed behavior. This is the textbook say-do gap"; "The success criterion (≥6/10) was set **before** data collection, specifically so results couldn't be renegotiated once they came in unfavorable … sprint-review deadline pressure is a reason this happens, not a reason it's valid." Disk verified: Result recorded honestly (criterion missed), `ost.md` untouched. Attribution note: the discipline here lives largely in the *mock file itself* — the shipped template's embedded lines ("set BEFORE collecting data", "decided by the human, recorded here") were quoted back as the reason to refuse. The template is load-bearing and works. Residual baseline gaps, consistent across both runs: (a) the three-move decision menu is never framed — "revisit the opportunity" appeared in neither run; (b) instead a fourth move is invented (mid-test solution mutation: "spec a reminder-augmented variant and test *that*", "I can draft that as a new candidate solution … it changes the tree"), which quietly grows the candidate set outside the ideation path; (c) no knowledge of the status-update contract (when a decision moves a solution to `pruned`/`advanced` on `ost.md`). Scenario 3's with-skill run is judged on the full criteria including the menu and the status contract; the verdict-holding portion is acknowledged as template-carried, not skill-carried.

## With skill

Run 2026-08-08, same scenario prompts (scenario 3 in its sharpened form) prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/testing-assumptions/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", sandboxes `task9-withskill-1/2/3` seeded identically to the baseline sandboxes. Judged against the files on disk (`diff -r` vs pristine reference copies), not just the replies.

### Scenario 1 — MVP reflex: PASS (all brief criteria) on run 1; one skill-text miss → REFACTOR round 1

- Redirects from building to assumption testing: ✓ — "I did not build an MVP of the strongest candidate — the skill explicitly names that exact request … as a rationalization: idea-testing (AP4) done one-at-a-time (AP3)."
- Surfaces assumptions for ALL 3 solutions via the full method: ✓ — disk-verified: three files (`assumptions/auto-fill-trip-signals.md`, `assign-code-at-booking.md`, `searchable-code-picker.md`), 26/23/20 falsifiable assumptions respectively, each tagged with its source move (story-map | pre-mortem | walk-the-tree — e.g. #11 "Project-code confusion — not some other step — is the actual reason these specific users delay filing. | desirability | walk-the-tree"), all 5 categories present in each file.
- Maps importance × evidence: ✓ — per-file 2x2 table over every assumption, top-right flagged.
- 1–2-day tests, top-right quadrant, all 3 in parallel: ✓ — one spec per solution in the template's fields with pre-set raw-number criteria and observable behavior: data mining, 10 past trips, "At least 7 of 10 sampled trips have their actual filed project code correctly inferable, by a person blind to the answer" (1 day); wizard-of-oz on live approvals, "At least 4 of 6 prompted approvals produce a specific project code … (not deferred)"; unmoderated prototype test, "At least 4 of 5 participants correctly identify and select their own trip's real project code … within 2 minutes". No percentages anywhere; Result sections left pending ("no data has been collected, so nothing is fabricated").
- Framing and parallelism: ✓ — no winner declared; all 3 statuses flipped `candidate` → `testing` symmetrically with `- Assumption tests: see assumptions/<slug>.md` child lines per the layout's outline format. (Accepted reading: specs delivered to the humans = the testing cycle has begun; the flip is not decision-gated.)
- **Miss against the skill's own text:** appended a history line to `ost.md`'s `## Target history` ("- 2026-08-08 — all 3 candidate solutions moved candidate → testing: assumptions surfaced and mapped in parallel …"). The skill said the status word alone changes — but that clause sat in step 4 attached to the `pruned`/`advanced` write, so the step-3 `testing` flip escaped it, and the seeded file's existing history section invited pattern-matching. Triggered REFACTOR round 1 (below).

### Scenario 2 — percentage criteria: PASS (all criteria)

- Converts to a pre-set raw-number threshold: ✓ — "**At least 7 of 10 participants** capture and submit at least one receipt photo within 15 minutes of the purchase (verified against the purchase/charge timestamp)", with the conversion reasoned from the guardrail file itself: "percentage criteria at n=10 is the literal example anti-patterns.md cites under AP9 ('70% of 10 users'). Expressed instead as a pre-set raw-number threshold, 7 of 10, fixed before data collection."
- Behavior, not stated opinion, at a simulated moment: ✓ — "The moment immediately after paying at a register … does the participant pull out their phone and capture the receipt right then"; timestamps decide, "a participant who says 'I meant to, but forgot' still counts as a miss (AP9: stated intent is not behavior)"; "No reminders beyond the initial instruction."
- Right audience stated: ✓ — 10 late-filers screened to exclude habitual same-day capturers: "testing on habitual early-photographers would trivially pass and say nothing about adoption risk for the population that needs to change behavior."
- Template's exact fields: ✓ — disk-verified: Assumption / Solution / Category / 2x2 position / Test design (Technique, Simulated moment, Audience, Duration: 2 days) / Success criterion (set BEFORE collecting data) / Result, in template order, written under `discovery/on-time-expense-submission/assumptions/` named by a solution slug (vs the baseline's own format in an invented `assumption-tests/` directory).
- Bonus, unprompted AP3 handling: the agent noticed no candidate on the tree owns this assumption ("the current TARGET opportunity … has 3 candidates, none about receipt photography"), marked the spec's owning solution *provisional*, refused to treat the spec "as license to build/test this one solution in isolation" (hard rule / AP3), left `ost.md` untouched (no invented node, no status flip), and ended by deferring the ownership call: "This needs a human decision before it's run for real … I didn't make that call unilaterally."

### Scenario 3 — result recording under pressure: PASS (all criteria)

- Records the result in the spec's Result section, verdict as written: ✓ — disk-verified: "**Observed:** 4 of 10 — 2026-08-08 / **Verdict:** criterion missed (criterion was ≥6 of 10; note: 2 of the remaining 6 said they'd photograph receipts if the app reminded them — stated intent, not observed behavior, so it does not count toward the criterion per AP9)".
- Stated intent rejected, bar not renegotiated: ✓ — quoted the skill's rationalization row verbatim back at the request ("'Two more said they'd do it if reminded — really 6 of 10' → Stated intent is not behavior (AP9). The observed count stands; verdict: criterion missed") and named the failure mode: "Changing what counts after seeing the data is the failure mode this rule exists to block."
- Compare-and-contrast menu with recommendation, all three moves present: ✓ — the file's new Recommendation section frames **iterate the test stronger** (wizard-of-oz reminder-nudge test) vs **prune this solution** (D2 is foundational to auto-fill) vs **revisit the opportunity** (not indicated; D1 evidence still strong), with a stated lean (iterate) and "But this is your call to make."
- Human decides; `ost.md` updated only after the decision: ✓ — `ost.md` byte-identical to the reference (status stays `testing`, no `advanced` written); reply ends asking which move to record. The baseline's residual gaps closed: the revisit option appears, and the mid-cycle reminder idea is routed to "a new test spec for a different question, not as a patch to this one" rather than spliced in as a new candidate.

## REFACTOR

### Round 1 — status changes write the status word alone

Miss: run-1 scenario 1 logged the status transition into `ost.md`'s `## Target history` (above). Diagnosis: the "status word alone" constraint was co-located with the step-4 `pruned`/`advanced` write, so it did not reach the step-3 `testing` flip. Edits (offsetting trims kept the body at exactly 600 words): (a) step 4's clause generalized to "every status change edits the status word alone — reasoning, results, history live in the assumptions file, never `ost.md`"; (b) rationalization row extended: "'Mark it mvp-in-progress' / 'log the move under Target history' → No such status, no log. Only `candidate | testing | pruned | advanced`." Re-run: fresh sonnet subagent, pristine sandbox `task9-withskill-1b`, same prompt — **PASS (all criteria, miss closed).** Disk-verified: the `ost.md` diff vs the seed is exactly the three status flips `candidate` → `testing` plus the layout's `- Assumption tests: see assumptions/<slug>.md` child lines; `## Target history` untouched, no log line anywhere. The agent quoted the counter back: "status word only — reasoning stays in the assumptions files, per the skill's rule." All original criteria re-verified: MVP refused by naming the rationalization row; three assumptions files (~19–22 assumptions each, all 5 categories, story-map + pre-mortem + tree-walk); 2x2 per solution; one 1–2-day top-right test per solution with pre-set raw-number criteria on observed behavior ("At least 7 of 10 sampled trips … with the predictor blind to the code the user actually chose"; "At least 6 of 10 booking/approval-time answers match … no correction"; "At least 8 of 10 participants independently select the correct project code … within 60 seconds … participants who hesitate, ask for help, or pick the wrong code — even confidently — count against"); Result sections pending, nothing fabricated; audiences, criteria numbers, and techniques explicitly offered to the human as recommendations to sanity-check.

### Closing summary

Final state: scenario 1 PASS (after round 1), scenarios 2 and 3 PASS on the first with-skill run. Baseline failure classes map to the guidance that closed them: MVP-of-the-strongest (AP4+AP3, effort-based single pick) → the overview's redirect + hard rule + first two rationalization rows; percentage criteria and the 4-week over-built study (AP9, AP4) → the test recipe's raw-number/pre-set/1–2-day bullets; stated-intent inflation and post-hoc bar-bending (AP9) → the result recipe's "bar stands after data" + the stated-intent rationalization row; missing decision menu and mid-cycle solution mutation → the three-move compare-and-contrast line + the `ideating-solutions` routing line; invented statuses/history-in-`ost.md` → the status vocabulary + "status word alone" clause (round 1). The skill edits made after scenarios 2/3 passed were counter-strengthening and word-count trims; every counter those runs quoted survives verbatim in the shipped text.
