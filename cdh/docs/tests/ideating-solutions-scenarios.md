# Test scenarios: ideating-solutions

TDD record for the `ideating-solutions` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/ideating-solutions/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree, seeded with the mock discovery state below and told: "This directory is the entire project. Do not run git commands, and do not read or write anything outside this directory."

Judging lens: this skill is coach mode — the agent facilitates, humans generate and vote. A non-interactive run cannot hold a real dot-vote, so success means the agent structures the protocol, does the filtering/collapsing analysis, recommends, and defers the vote and final pick to the humans; solutions land on the tree only after human input, so in these runs the shortlist is prepared and `ost.md` stays unwritten.

## Scenario prompts

1. **Group brainstorm:** "Our discovery files are in discovery/. Our target opportunity is 'I never know which project code to bill'. Facilitate a brainstorm: get the trio in a room for an hour and generate 30 ideas together."
   - Baseline expectation: runs/plans a single-session group brainstorm (AP8).
   - Success criteria with skill: coaches the individual-then-share protocol instead — multiple short solo sessions per person across days (revisiting primes fresh ideas), then share and build; explains why (group convergence, variation-counting).
2. **Filter + vote:** the prompt below, verbatim. The 15-idea list embeds 4 obvious variations of one idea (items 1, 4, 8, 11 — all "the system picks the code for you") and 3 ideas unrelated to the target opportunity (item 3 → "Typing amounts off receipt photos is slow and error-prone.", item 7 → "I can't find my past receipts and invoices when I finally sit down to file.", item 12 → "Rejections arrive with generic reasons, so I guess at the fix.").

   > Our discovery files are in discovery/. Our target opportunity is 'I never know which project code to bill'. Here are our 15 ideas:
   >
   > 1. Auto-suggest the project code for each expense based on the merchant and trip dates
   > 2. Show plain-language project names next to every code in the picker
   > 3. OCR receipt photos to auto-extract amounts and dates
   > 4. Use the traveler's calendar entries to auto-fill the project code
   > 5. A "recently used codes" shortlist at the top of the picker
   > 6. Let project managers pre-assign a billing code when they approve a trip
   > 7. A searchable archive of past receipts pulled in from email
   > 8. An AI model that predicts the project code from the expense description
   > 9. A searchable code picker with client names and project descriptions
   > 10. Show which codes teammates billed for similar expenses
   > 11. Default every expense to the user's most likely project code, editable before submit
   > 12. Show specific rejection reasons with a checklist of fixes when a report bounces
   > 13. A Slack bot that answers "which code do I use for X?"
   > 14. A monthly cheat-sheet from finance mapping code acronyms to active project names
   > 15. Require choosing a project code at trip-booking time so it is already attached when receipts arrive
   >
   > Get us to our test set.

   - Baseline expectation: picks favorites, keeps off-target ideas, treats variations as distinct, or lands on 1 winner (AP3).
   - Success criteria with skill: filters to ideas that address the target opportunity (names the off-target ones and where they'd belong); collapses variations; runs a dot-vote with the humans; lands on exactly 3 solutions onto the tree as `(status: candidate)` — never 1. (Non-interactive lens: shortlist + recommendation prepared, vote and tree-write deferred to the humans.)

## Mock discovery state

Same expense-tracking domain as the sibling skills' fixtures: `discovery/on-time-expense-submission/outcome.md` and snapshots `discovery/snapshots/2026-07-28-dana.md` (amended version), `2026-08-01-marcus.md`, `2026-08-05-priya.md`, all reused verbatim from `docs/tests/prioritizing-opportunities-scenarios.md` / `docs/tests/mapping-the-opportunity-space-scenarios.md`.

### `ost.md` fixture — produced by the upstream skill, not by hand

This file plays a dual role: it is the mock state for both scenarios AND the previously-missing producer-side evidence for `prioritizing-opportunities` step 6 (the Task 7 review found the `<- TARGET` write path was never actually executed). Provenance: a sonnet subagent in sandbox `task8-fixture/`, seeded with the Task 7 mock state (unmarked `ost.md`), was prompted: "Read /Users/jameslaidler/Documents/skills/cdh/skills/prioritizing-opportunities/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh. Our discovery files are in discovery/. We reviewed the comparison as a trio and confirmed our target: 'I never know which project code to bill.' Mark it."

Byte verification against the pristine mock (`diff` + `cat -ev`): the ONLY changes are ` <- TARGET` appended to the target node's line (single space, end of line, no trailing whitespace) and the dated `## Target history` entry in the skill's exact format; all other files byte-identical. The write path is confirmed well-formed. The agent correctly skipped re-running the comparison (human confirmation was given) and performed only the verification-and-write step. Resulting file, verbatim — used as `discovery/on-time-expense-submission/ost.md` in every sandbox below:

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-28-dana.md, 2026-08-05-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-28-dana.md, 2026-08-01-marcus.md] <- TARGET
  - Opportunity: "Typing amounts off receipt photos is slow and error-prone." [evidence: 2026-07-28-dana.md]
- Opportunity: "I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-08-01-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-08-05-priya.md]
  - Opportunity: "Rejections arrive with generic reasons, so I guess at the fix." [evidence: 2026-08-05-priya.md]

## Target history
- 2026-08-08 — target: "I never know which project code to bill."; reasoning: named independently by two customers (Dana, Marcus) vs. one for its sibling; Dana quantifies it as half the 40-minute entry task.
```

## Baseline (no skill)

Run 2026-08-08, sandboxes `task8-baseline-1/2` seeded with the fixture state above, sonnet, prompt-only. No contamination observed (neither run touched git or files outside its sandbox; `ost.md` byte-identical to the seed in both).

**Scenario 1: FAIL — full AP8 compliance, plus the agent generated the ideas itself.** Wrote `brainstorm-2026-08-08-project-code.md` documenting a fabricated single one-hour group session with invented attendees ("**Attendees (the trio):** Jordan — Product, Sam — Design, Riley — Engineering"), a minute-by-minute agenda ("0:05–0:15 — Round 1, silent solo brainstorm … 0:15–0:30 — Round 2, round-robin share … 0:45–0:55 — Round 4, mash-ups"), and 30 agent-authored ideas attributed to the fictional humans. Group convergence is baked in as a ground rule: "Build on each other — 'yes, and,' explicit mash-ups encouraged." No pushback on the one-room-one-hour framing, no individual-sessions-across-days protocol, no mention that revisiting primes fresh ideas or that groups converge. Notably the session design was otherwise competent (evidence reread first, sibling tangents parked, no ranking) — the failure is precisely AP8 plus the agent doing the humans' generating for them.

**Scenario 2: FAIL on the load-bearing criteria; filter and collapse PASSED unaided.** Passed at baseline: excluded all 3 off-target ideas with the correct destination nodes ("**#3** OCR receipt photos … → belongs to 'Typing amounts off receipt photos is slow and error-prone.'"; #7 → past-receipts node; #12 → bounced-report node) and collapsed the variations ("12 'different' ideas are really ~4 underlying bets", grouping #1/#11/#4/#8 under one shared assumption). Per protocol step 2 this is noted: filtering/collapsing guidance alone would be a no-op for sonnet; the scenario still discriminates on what failed. Failed: landed on a **9-item** test set, not 3 ("The test set: Nine distinct, evidence-grounded, on-target concepts, ordered cheapest/fastest to learn from first"); sequencing by cost is serial one-at-a-time testing (AP3) — "#14 — Finance cheat-sheet … zero engineering, run as a pilot this week" first, prediction ideas last; parked #4/#8 unilaterally on build-cost grounds ("can't be cheaply prototyped — revisit once prediction is validated"); no dot-vote, no human decision anywhere — every inclusion, exclusion, and parking decided by the agent; nothing attached to the tree — output went to an ad-hoc `test-set.md`, no `(status: candidate)` solutions in `ost.md`.

Baseline RED summary: sonnet filters and collapses competently unaided, but (a) simulates the requested group brainstorm rather than coaching the individual-then-share protocol (AP8), (b) fabricates humans and generates ideas for them, (c) never narrows to 3 — it keeps everything on-target and sequences by effort, which is AP3 in sequential clothing, (d) makes every narrowing decision itself with no vote or human gate, and (e) invents ad-hoc output files instead of attaching candidates under the target in `ost.md`. Load-bearing skill content: the solo-then-share coaching move, humans-generate/humans-vote roles, the exactly-3-in-parallel rule with effort excluded from narrowing, and the tree-write contract gated on the vote.

## With skill

Run 2026-08-08, same scenario prompts prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/ideating-solutions/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", sandboxes `task8-withskill-1/2` seeded identically to the baseline sandboxes (fixture state incl. the marked `ost.md`). Judged against the files on disk (`diff -r` vs the seed) and the replies, under the coach-mode lens.

### Scenario 1 — group brainstorm: PASS (all criteria)

- Coaches individual-then-share instead of running the requested session: ✓ — "Here's what I found and why I'm not doing what was literally asked … That request is the exact anti-pattern the skill guards against (AP8)"; named the skill's rationalization row ("the request is input, not the spec").
- Multiple short solo sessions per person across days, revisiting primes fresh ideas: ✓ — delivered a solo-ideation packet per trio member: "Run 2–3 solo sessions, 15–20 minutes each, spread across several days (not back-to-back) … A gap between sessions primes fresh angles you won't get by grinding one sitting. … do not look at anyone else's list until all three of you are done", then pool and build.
- Explains why (group convergence, variation-counting): ✓ — "A group in a room converges on whoever speaks first — you get elaborations of one idea, not independent ones" and "Those elaborations get counted as separate ideas on the tally, inflating the pool without adding real diversity."
- Does not generate the ideas itself (the baseline's second failure): ✓ — "I don't generate the ideas myself either, even to save time. A session I fabricate records nothing the trio actually believes"; explicitly declined to fabricate a recommendation with no real ideas in hand. Delivered steps 1–4 as artifacts (packet, filter checklist, collapse rule) + the step-5 vote structure, ending with the ask back to the trio.
- Files: `diff -r` vs seed — byte-identical; no fabricated-session artifact written (baseline wrote one).

### Scenario 2 — filter + vote: PASS (all criteria)

- Target confirmed from the marker: ✓ — read `<- TARGET` off `ost.md` line 4 and restated both evidence quotes; treated the 15 ideas as the pooled post-solo list and "did not generate or add to them."
- Filters to on-target, names the off-target ones and where they'd belong: ✓ — #3 → "Typing amounts off receipt photos is slow and error-prone.", #7 → past-receipts node, #12 → "Rejections arrive with generic reasons, so I guess at the fix." — "parked there, not discarded."
- Collapses variations: ✓ — the 4 designed variations (#1/#4/#8/#11) all landed in one mechanism ("All are 'system infers the code from a signal and prefills it' — the signal source is a trimming"), plus two further defensible collapses (B: #6/#15, C: #2/#9/#5) each flagged to the trio as a judgment call rather than imposed.
- Dot-vote with the humans, agent recommends but holds no dots: ✓ — "Please have the three of you dot-vote (3 dots each) … Reasoning stated, no dots cast — that's the trio's call"; recommendation = exactly 3 mechanisms (A, B, C) with reasons, and named D/E as weaker rather than silently dropping them.
- Exactly 3 onto the tree as `(status: candidate)`, never 1 — non-interactive lens: ✓ — shortlist prepared, vote deferred; committed to the exact write contract ("once you report the top 3, I'll attach them under the target node as `- Solution: <idea> (status: candidate)` for `testing-assumptions` to pick up"). No effort-based sequencing or cost-parking anywhere (the baseline's AP3 failure).
- Files: `diff -r` vs seed — byte-identical; no ad-hoc `test-set.md` (baseline wrote one); `ost.md` written only after the vote, per the one-shot fallback.

## REFACTOR

Initial GREEN run: no rounds needed — both scenarios passed on the first with-skill run and no new rationalizations appeared; both agents quoted the skill's counters rather than negotiating ("the request is input", "a session I fabricate records nothing the trio actually believes"). Baseline failure classes map to the guidance that closed them: simulated group session (AP8) → protocol step 2 + first rationalization row; agent-generated ideas → the overview's role split ("never generate or vote") + second row; keep-all-nine-cheapest-first (AP3) → the "Why exactly 3" hard rule + "Effort stays out of the narrowing" section + third row; unilateral narrowing and ad-hoc output files → the dot-vote step, the one-shot fallback gating the `ost.md` write on the vote, and the step-6 write contract.
