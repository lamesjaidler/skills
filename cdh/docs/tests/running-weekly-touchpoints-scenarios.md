# Test scenarios: running-weekly-touchpoints

TDD record for the `running-weekly-touchpoints` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/running-weekly-touchpoints/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree, seeded with the mock discovery state below and told: "This directory is the entire project. Do not run git commands, and do not read or write anything outside this directory."

Judging notes: "today" for every subagent is 2026-08-08 (harness-injected date); all mock dates are set relative to it so the staleness math is fixed (newest snapshot 2026-07-18 = 3 weeks old; metric last recorded 2026-06-27 = 6 weeks old). Runs are non-interactive, so wherever a criterion says the human decides or answers, success is recommendation/question + deferral, with the touchpoint log recording the item as pending — never a unilateral decision or an invented metric reading. Scenario 1's log criterion is judged on bytes on disk (`touchpoints/2026-08-08.md` exists with decisions + staleness), not on a described intention. Scenario 3 is a standalone stakeholder-prep request; it is judged on the walkthrough only, no log required.

## Scenario prompts

1. **Health check:** "Our discovery files are in discovery/. Run our weekly discovery touchpoint."
   - Sandbox state: outcome.md + ost.md with one evidence-less branch + auto-fill assumptions file whose test spec has NO Result section + redated snapshots (below). No touchpoints/ dir yet (first ritual).
   - Baseline expectation: generic status summary; misses staleness; no measurement prompt; no log written.
   - Success criteria with skill: reports interview staleness ("3 weeks since last interview") and the starving branch; chases the unrecorded test result; asks "did the outcome metric move?" and records the answer (non-interactive: question asked, logged as pending); writes `touchpoints/2026-08-08.md` with decisions and staleness items — verified on disk.
2. **Cycle decision:** "Our discovery files are in discovery/. Our fake-door test failed its criterion this week — what should the team do?"
   - Sandbox state: outcome.md + ost.md (3 solutions under the target: one `testing`, two `candidate`) + assign-code-at-booking assumptions file with the fake-door Result filled: 2 of 8, criterion missed, Decision pending + snapshots.
   - Baseline expectation: yes/no advice ("kill it" / "keep going") — AP10.
   - Success criteria with skill: frames the cycle options compare-and-contrast (stronger test on same assumption / prune solution and continue with remaining ≥2 — flagging that pruning drops the candidate count below 3 / revisit target opportunity / harvest new evidence); names which tree node each option revisits; recommends; human decides (non-interactive: recommendation + deferral); decision logged — `touchpoints/2026-08-08.md` written with the pending decision noted.
3. **Stakeholder prep:** "Our discovery files are in discovery/. Our VP wants an update on discovery. Draft what we should tell them."
   - Sandbox state: the full-trail mock — ost.md with one pruned and two testing solutions, three assumptions files (one criterion met, one missed → pruned, one pending), prior touchpoint log 2026-08-01, outcome.md, snapshots.
   - Baseline expectation: conclusions-only status report (AP11).
   - Success criteria with skill: builds a show-your-work walkthrough — outcome, tree structure, evidence trail, tests run and numbers, the decision points where alternatives were compared — not bare conclusions.

## Mock discovery state

Same expense-tracking domain as every sibling fixture, with snapshots REDATED (3-week staleness for scenario 1) — contents otherwise verbatim from `docs/tests/mapping-the-opportunity-space-scenarios.md` (amended Dana version): dana 2026-07-28 → 2026-07-04, marcus 2026-08-01 → 2026-07-11, priya 2026-08-05 → 2026-07-18. Evidence tags and H1 dates updated to match; all three snapshots seeded in every sandbox.

`discovery/snapshots/2026-07-04-dana.md`:

```markdown
# Interview Snapshot: Dana — 2026-07-04

**Source:** interview — transcript on file

## Vivid quote

> "Typing amounts off photos at 10pm is the worst part of my job, and it isn't even my job."

## Quick facts

- Sales rep, travels 2–3x/month, files reports 1–2 weeks late
- Photographs every receipt into a phone album, throws away paper

## Opportunities heard

- "Entering each receipt by hand takes forever."
- "I never know which project code to bill — that's half the forty minutes of typing them in."
- "I always mean to do the report on the flight home and never do."

## Interesting insights

- Has a workaround system (photo album) but still delays the typing step

## Experience map slice

Capture and entry steps: receipts photographed same-day, typed in batch days later.
```

`discovery/snapshots/2026-07-11-marcus.md`:

```markdown
# Interview Snapshot: Marcus — 2026-07-11

**Source:** interview — transcript on file

## Vivid quote

> "By the time I sit down to file, half my receipts have vanished into email."

## Quick facts

- Consultant, expenses weekly, usually files a week late
- Keeps receipts across email, a downloads folder, and the app

## Opportunities heard

- "I never know which project code to bill — the names are all acronyms."
- "I can't find my past receipts and invoices when I finally sit down to file."

## Interesting insights

- Hunting for scattered receipts adds a day before he can even start the report

## Experience map slice

Gather step: receipts scattered across email, downloads, and the app; assembled by hand at filing time.
```

`discovery/snapshots/2026-07-18-priya.md`:

```markdown
# Interview Snapshot: Priya — 2026-07-18

**Source:** interview — transcript on file

## Vivid quote

> "It bounced back twice and nobody told me what was actually wrong."

## Quick facts

- Engineering manager, files quarterly, approves her team's reports
- Reports bounce back for code and policy errors

## Opportunities heard

- "Entering each receipt takes forever, so I put it off."
- "My report bounced back and I didn't know why."

## Interesting insights

- Rejection loops add a week+ to submission time

## Experience map slice

Approval step: rejections arrive with generic reasons; users guess at the fix.
```

`discovery/on-time-expense-submission/outcome.md` (all scenarios; metric last recorded 2026-06-27 = exactly 6 weeks before today):

```markdown
# Outcome: on-time-expense-submission

## Outcome statement
Increase the share of users who submit their expense report within 5 days of trip end.

## Metric
Share of reports submitted within 5 days of trip end; baseline 34%, target 55%; data source: submissions DB.

## History
- 2026-06-08 — set: derived from "reduce finance close delays"; chosen over a report-accuracy candidate.
- 2026-06-27 — metric recorded: 34% (baseline reading, submissions DB).
```

### Scenario 1 fixtures

`discovery/on-time-expense-submission/ost.md` — Task 9's fixture tree redated, auto-fill in `testing`, plus one evidence-less branch (the approver line, added by hand without a snapshot — the starving branch):

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-04-dana.md, 2026-07-18-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-04-dana.md, 2026-07-11-marcus.md] <- TARGET
    - Solution: Auto-fill the project code from trip signals (calendar, merchant, trip dates) (status: testing)
      - Assumption tests: see assumptions/auto-fill-project-code.md
    - Solution: Assign the project code upstream at trip booking/approval time (status: candidate)
    - Solution: A searchable code picker with plain-language project names and recently used codes (status: candidate)
  - Opportunity: "Typing amounts off receipt photos is slow and error-prone." [evidence: 2026-07-04-dana.md]
- Opportunity: "I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-07-11-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-07-18-priya.md]
  - Opportunity: "Rejections arrive with generic reasons, so I guess at the fix." [evidence: 2026-07-18-priya.md]
- Opportunity: "Approvers sit on reports for days before looking at them."

## Target history
- 2026-07-21 — target: "I never know which project code to bill."; reasoning: named independently by two customers (Dana, Marcus) vs. one for its sibling; Dana quantifies it as half the 40-minute entry task.
```

`discovery/on-time-expense-submission/assumptions/auto-fill-project-code.md` — Task 9's fixture with the spec's Result section REMOVED (test launched 2026-08-03, number never recorded):

```markdown
# Assumption Map: auto-fill-project-code

**Solution:** Auto-fill the project code from trip signals (calendar, merchant, trip dates)
**Target opportunity:** "I never know which project code to bill." [evidence: 2026-07-04-dana.md, 2026-07-11-marcus.md]

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

- High importance / weak evidence (test now): F1
- High importance / strong evidence: D1 (Dana photographs every receipt same-day; both interviews name code-picking as the pain)
- Low importance / weak evidence: E1 (watch; retest if calendar signal survives)
- Low importance / strong evidence: V1 (finance derives codes from trips today)

## Test specs

# Assumption Test: trip signals identify the right code

**Assumption:** Calendar and merchant data identify the right project code for most expenses.
**Solution:** auto-fill-project-code
**Category:** feasibility
**2x2 position:** importance high / evidence weak

## Test design

**Technique:** data mining
**Simulated moment:** a past trip's filed expenses — a person blind to the answer infers the project code from calendar and merchant data alone; we compare against the code actually filed.
**Audience:** 10 already-filed trips sampled across departments; no participants needed.
**Duration:** 1 day (run 2026-08-03)

## Success criterion (set BEFORE collecting data)

At least 7 of 10 sampled trips have their actual filed project code correctly inferable by a person blind to the answer.
```

### Scenario 2 fixtures

`discovery/on-time-expense-submission/ost.md`:

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-04-dana.md, 2026-07-18-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-04-dana.md, 2026-07-11-marcus.md] <- TARGET
    - Solution: Auto-fill the project code from trip signals (calendar, merchant, trip dates) (status: candidate)
    - Solution: Assign the project code upstream at trip booking/approval time (status: testing)
      - Assumption tests: see assumptions/assign-code-at-booking.md
    - Solution: A searchable code picker with plain-language project names and recently used codes (status: candidate)
  - Opportunity: "Typing amounts off receipt photos is slow and error-prone." [evidence: 2026-07-04-dana.md]
- Opportunity: "I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-07-11-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-07-18-priya.md]
  - Opportunity: "Rejections arrive with generic reasons, so I guess at the fix." [evidence: 2026-07-18-priya.md]

## Target history
- 2026-07-21 — target: "I never know which project code to bill."; reasoning: named independently by two customers (Dana, Marcus) vs. one for its sibling; Dana quantifies it as half the 40-minute entry task.
```

`discovery/on-time-expense-submission/assumptions/assign-code-at-booking.md`:

```markdown
# Assumption Map: assign-code-at-booking

**Solution:** Assign the project code upstream at trip booking/approval time
**Target opportunity:** "I never know which project code to bill." [evidence: 2026-07-04-dana.md, 2026-07-11-marcus.md]

## Assumption list (abridged)

### Desirability
- D1. Trip bookers are willing to pick the project code at booking time.
### Viability
- V1. Finance accepts a code assigned weeks before the expense exists.
### Feasibility
- F1. The booking tool can carry a project-code field through to the expense app.
### Usability
- U1. Bookers can find the right code at booking time without help.
### Ethical
- (none surfaced yet)

## 2x2 map (importance × evidence)

- High importance / weak evidence (test now): D1
- High importance / strong evidence: F1 (booking tool has custom fields; export path confirmed)
- Low importance / weak evidence: U1, V1

## Test specs

# Assumption Test: bookers assign codes at booking

**Assumption:** Trip bookers are willing to pick the project code at booking time.
**Solution:** assign-code-at-booking
**Category:** desirability
**2x2 position:** importance high / evidence weak

## Test design

**Technique:** fake-door
**Simulated moment:** the booking-confirmation screen — a "Set the project code for this trip now" button; we observe whether the booker clicks it and completes the code picker that follows.
**Audience:** employees booking their own work trips this week (not travel admins); they are the ones the code would come from.
**Duration:** 2 days

## Success criterion (set BEFORE collecting data)

At least 4 of 8 bookers who see the button click it and complete the code picker.

## Result

**Observed:** 2 of 8 — 2026-08-06
**Verdict:** criterion missed
**Decision:** <keep going | iterate to a bigger/stronger test | prune solution | revisit opportunity> — decided by the human, recorded here.
```

### Scenario 3 fixtures

`discovery/on-time-expense-submission/ost.md` — the downstream state: one pruned (human-decided 2026-08-01), two testing:

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-04-dana.md, 2026-07-18-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-04-dana.md, 2026-07-11-marcus.md] <- TARGET
    - Solution: Auto-fill the project code from trip signals (calendar, merchant, trip dates) (status: testing)
      - Assumption tests: see assumptions/auto-fill-project-code.md
    - Solution: Assign the project code upstream at trip booking/approval time (status: pruned)
      - Assumption tests: see assumptions/assign-code-at-booking.md
    - Solution: A searchable code picker with plain-language project names and recently used codes (status: testing)
      - Assumption tests: see assumptions/searchable-code-picker.md
  - Opportunity: "Typing amounts off receipt photos is slow and error-prone." [evidence: 2026-07-04-dana.md]
- Opportunity: "I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-07-11-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-07-18-priya.md]
  - Opportunity: "Rejections arrive with generic reasons, so I guess at the fix." [evidence: 2026-07-18-priya.md]

## Target history
- 2026-07-21 — target: "I never know which project code to bill."; reasoning: named independently by two customers (Dana, Marcus) vs. one for its sibling; Dana quantifies it as half the 40-minute entry task.
```

`assumptions/auto-fill-project-code.md`: scenario 1's file PLUS a filled Result section on the data-mining spec:

```markdown
## Result

**Observed:** 8 of 10 — 2026-08-01
**Verdict:** criterion met
**Decision:** iterate to a bigger/stronger test (wizard-of-oz prefill on live reports) — decided by the human, recorded 2026-08-01.
```

`assumptions/assign-code-at-booking.md`: scenario 2's file with the Decision line replaced by:

```markdown
**Decision:** prune solution — decided by the human, recorded 2026-08-01.
```

`assumptions/searchable-code-picker.md`:

```markdown
# Assumption Map: searchable-code-picker

**Solution:** A searchable code picker with plain-language project names and recently used codes
**Target opportunity:** "I never know which project code to bill." [evidence: 2026-07-04-dana.md, 2026-07-11-marcus.md]

## Assumption list (abridged)

### Desirability
- D1. Travelers would rather search a plain-language list than ask a colleague for the code.
### Viability
- V1. Project owners will maintain plain-language names.
### Feasibility
- F1. Plain-language names can be sourced from the project registry.
### Usability
- U1. Travelers can find their trip's correct code by search alone, without a reference sheet.
### Ethical
- (none surfaced yet)

## 2x2 map (importance × evidence)

- High importance / weak evidence (test now): U1
- High importance / strong evidence: D1 (both interviews describe asking colleagues today)
- Low importance / weak evidence: V1, F1

## Test specs

# Assumption Test: codes findable by search alone

**Assumption:** Travelers can find their trip's correct code by search alone, without a reference sheet.
**Solution:** searchable-code-picker
**Category:** usability
**2x2 position:** importance high / evidence weak

## Test design

**Technique:** prototype
**Simulated moment:** the code-entry field of a real past trip — participant uses a clickable picker seeded with real project names to find the code they actually billed.
**Audience:** 5 travelers who filed a report in the last month (own reports, not admins).
**Duration:** 2 days (in field, results due 2026-08-10)

## Success criterion (set BEFORE collecting data)

At least 4 of 5 participants select their own trip's correct project code within 2 minutes.

## Result

**Observed:** pending — results due 2026-08-10
**Verdict:** pending
**Decision:** pending
```

`touchpoints/2026-08-01.md` (prior ritual log — the decision trail):

```markdown
# Touchpoint: 2026-08-01

## Staleness
- Newest snapshot 2026-07-18 — 14 days old; interviews slipping, recruiting restarted.

## Measurement
- Product outcome: 36% of reports submitted within 5 days (submissions DB, week of 2026-07-27); baseline 34%, target 55%.
- Business outcome (finance close delay): no new reading this week.

## Decisions
- Fake-door on assign-code-at-booking (2 of 8, criterion missed): compared stronger-test-same-assumption vs prune vs revisit target. Human decided: prune. Candidate count now 2 — below 3; ideation session scheduled to restore a third.
- Data mining on auto-fill (8 of 10, criterion met): human decided — iterate to a stronger test (wizard-of-oz prefill on live reports).
```

## Baseline (no skill)

Run 2026-08-08, sandboxes `task10-baseline-1/2/3`, sonnet, prompt-only. No contamination observed (no git, no reads or writes outside any sandbox). All three sandboxes `diff -r`-verified byte-identical to their pristine reference copies after the runs — no baseline wrote anything.

**Scenario 1: FAIL on the log, the measurement ask, and the starving branch; two staleness checks passed unaided.** The baseline produced a competent read-only synthesis: it caught interview staleness precisely ("Snapshots ran weekly for three straight weeks … Nothing since. That's three consecutive missed weeks") and chased the unrecorded test result ("It's now 5 days past that date with no result logged … needs a result recorded (or the test rerun) before the next touchpoint"). The discriminating failures: (a) **no log written** — disk verified untouched — with the rationalization verbatim: "No files needed changes — nothing here required fabricating new interview or test data, so I didn't invent any" (the touchpoint log conflated with fabricating data); (b) **measurement demoted to housekeeping** — the 6-week-old metric filed under "Minor housekeeping … Not urgent, but worth refreshing at the next monthly checkpoint" — the questions "did the outcome metric move? did the business outcome follow?" never asked, no number requested from the human; (c) **the starving branch missed** — the evidence-less "Approvers sit on reports for days" branch appears nowhere in the report; single-source branches were discussed, the zero-evidence one was not. The scenario retains discriminating power on exactly the load-bearing criteria; no sharpening needed.

**Scenario 2: FAIL — verdict-first advice with the decision pre-made; not naked yes/no, but a settled kill with alternatives as a rejection list.** Opened with the conclusion: "## Recommendation: Prune this solution, don't retest … I'd honor it: kill `assign-code-at-booking`, don't fund a bigger version of it." Alternatives were each argued *against* under the settled verdict ("Not 'revisit opportunity.' … Not 'iterate to a bigger/stronger test.' That's only justified if you have a specific reason to distrust the test's design or execution — a broken button, wrong audience, confusing copy") — the iterate option narrowed to instrument failure, excluding the standard small-weak-to-bigger-stronger rung. The human gate failed outright: "Concrete next steps: 1. Fill in the `Decision:` line in `assumptions/assign-code-at-booking.md` with 'prune solution' and this rationale. 2. Update `ost.md`: mark `assign-code-at-booking` as pruned … and promote *auto-fill from trip signals* to `testing`." Remaining misses: **no below-3 flag** (pruning leaves 2 candidates; instead it recommended testing them *sequentially* — "promote auto-fill … to `testing`", picker "worth a fast test" later — one at a time); **no harvest-new-evidence option**; tree-node naming unsystematic (only the revisit-opportunity paragraph names its node); **no touchpoint log** written or mentioned. Disk untouched (it told the team to write, rather than writing unilaterally — the gate failure is directive, not a write).

**Scenario 3: FAIL on show-the-tree and the evidence trail; the numbers discipline passed unaided (carried by the rich mock).** The draft is a polished status report — metric movement ("34% → 36% (target 55%)"), a results table with raw numbers and pre-set bars, the below-3 pipeline warning and interview-cadence slip lifted from the prior touchpoint log. The AP11 failures: (a) **the tree never appears** — only the target opportunity is named; its sibling opportunities, the branch structure, and the fact that alternatives existed at the target decision are absent (the target paragraph gives corroboration counts, but no tree to see them in); (b) **the evidence trail was deliberately dropped**: "I didn't include the underlying interview quotes in the draft — happy to add Dana's … if you want a human anchor for the VP"; (c) **decision points reported as bare outcomes** — the fake-door row ends "**Pruned.**" with no mention of the alternatives compared at that decision, even though the mock's touchpoint log records them ("compared stronger-test-same-assumption vs prune vs revisit target").

Baseline RED summary: unaided sonnet reads discovery state well but (a) treats the ritual as read-only — the log is "inventing data"; (b) demotes the weekly measurement question to a monthly chore; (c) scans evidence recency but not evidence *absence* (starving branches); (d) leads cycle decisions with a settled verdict, narrows the iterate option to broken instruments, drops to sequential single-candidate testing without a below-3 flag, and directs the human to record its decision; (e) briefs stakeholders with conclusions and numbers but strips the tree, the quotes, and the compared alternatives.

## With skill

Run 2026-08-08, same scenario prompts prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/running-weekly-touchpoints/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", sandboxes `task10-withskill-1/2/3` seeded identically to the baseline sandboxes. Judged against bytes on disk (`diff -r` vs pristine reference copies), not just the replies.

### Scenario 1 — health check: PASS (all criteria)

- Reports interview staleness: ✓ — log: "newest is `2026-07-18-priya.md` — 21 days old. Weekly cadence expects ≤7 days; discovery has slipped 3 weeks with no new interview harvested."
- Reports the starving branch: ✓ — "'Approvers sit on reports for days before looking at them.' … carries no `[evidence: …]` tag at all — the only node in `ost.md` with zero interview evidence behind it", cited as AP6; harvest move recommended for it with the Via routing from the skill's table.
- Chases the unrecorded test result: ✓ — "Its F1 test spec … was scheduled to run 2026-08-03 (1-day duration); `assumptions/auto-fill-project-code.md` has no `## Result` section 5 days later. The number needs chasing via testing-assumptions" — and it explicitly refused to pre-frame a kill-or-keep without the number: "presenting 'kill or keep' without the number would be guessing, not a decision (AP9/AP10)."
- Asks the measurement question and records the answer: ✓ (non-interactive form) — log's Measurement section quotes the question, then "No answer available this run — logging as an open question rather than a guessed number", with the open question spelled out.
- Writes the log: ✓ — `touchpoints/2026-08-08.md` verified on disk with the template's three sections, every staleness item, and both decisions marked "pending — human has not yet decided; no `ost.md` status changes this run." `diff -r` vs the pristine reference: only the touchpoints dir added. Bonus: ran the candidate-count check unprompted ("still has 3 solution candidates … no below-3 flag needed this run").

### Scenario 2 — cycle decision: PASS (all criteria)

- Compare-and-contrast, never yes/no: ✓ — the log's Decisions section holds the four-move table verbatim from the skill (stronger test / prune / revisit target / harvest new evidence) with a case-specific Notes column; reply framed it as "I compared all four standard moves (never a bare 'kill it or not')."
- Names which tree node each option revisits: ✓ — table's Revisits column: "D1's spec in `assumptions/assign-code-at-booking.md`" / "`ost.md` line 'Assign the project code upstream…' → `(status: pruned)`" / "'I never know which project code to bill.' `<- TARGET`" / "snapshots and the opportunity branch."
- Below-3 flag: ✓ — "**Flag in the same breath:** pruning drops the target opportunity's candidates from 3 to 2 … below the 3-candidate floor. Route to ideating-solutions to generate a third candidate before or alongside pruning; survivors are not tested one at a time (AP3)."
- Recommends; human decides: ✓ — recommendation stated (prune, margin-reasoned), then "**Decision:** pending — human has not yet decided. `ost.md` status is unchanged; this is a recommendation only."
- Decision logged: ✓ — `touchpoints/2026-08-08.md` on disk with the pending decision; `diff -r`: only the touchpoints dir added, `ost.md` and the assumptions file byte-identical.
- Residual nuance (no criterion failed): the iterate row's note reasons partly in the baseline's broken-instrument frame ("Nothing points at a broken instrument — iterating here would be 'give it another shot,' not a fix to a known flaw"), where the skill's line is that iterating needs no broken instrument. Behaviorally compliant — the option is presented in full and the final recommendation is margin-based, which the skill endorses ("margin shapes the recommendation") — so recorded as a nuance, not a miss.

### Scenario 3 — stakeholder prep: PASS (all criteria)

- Show-your-work walkthrough, not conclusions: ✓ — the draft runs step 4's order exactly: outcome with numbers ("Baseline 34% (2026-06-27) → latest 36% … → target 55%"); the tree's shape as an outline with the target marked and every sibling visible ("sibling, not yet worked" noted); the evidence trail with both project-code quotes verbatim (Dana's "that's half the forty minutes…", Marcus's "the names are all acronyms"); a tests table of pre-set criterion vs raw result ("≥4 of 8 | 2 of 8 — missed"); and each decision with the alternatives compared and who decided ("We compared: a stronger test of the same assumption, pruning it, or revisiting the target opportunity. Decided: prune"), including the below-3 flag and the auto-fill decision reasoned as "clearing a weak-evidence test earns a harder test, not a build decision."
- Scoping: correctly ran step 4 alone per the skill's standalone line — no ritual, no log write; sandbox `diff -r` byte-identical to the pristine reference.

## REFACTOR

No rounds needed: all three scenarios passed every success criterion on the first with-skill run, and no new rationalization appeared — the scenario-1 agent answered the baseline's "no files needed changes" excuse in behavior (log written on a run that changed nothing else) and the scenario-2 agent quoted the below-3/parallel counters rather than negotiating. Baseline failure classes map to the guidance that closed them: no-log-written ("nothing here required fabricating … data") → step 5's Done-when + "a quiet week still writes its log: … not invented data" + the first rationalization row; measurement demoted to a monthly chore → step 2's "every ritual" + its rationalization row; starving branch missed → the dedicated staleness bullet ("no `[evidence: …]` tag, or no recent one — starving branches"); verdict-first advice with the human directed to record it → step 3's recommend-then-human-decides with the pending-decision fallback and "The miss was decisive" row; sequential survivor testing with no below-3 flag → the prune row's "the rest keep testing in parallel" + the flag-in-the-same-breath sentence + the fourth rationalization row; missing harvest option and unsystematic node-naming → the four-move table with its Revisits column; conclusions-only stakeholder brief → step 4's positive in-order recipe and "a bare verdict always travels with the comparison that produced it." One residual nuance (scenario 2's broken-instrument phrasing inside a compliant comparison) is recorded above; per the iron law no skill edit was made against a passing run.
