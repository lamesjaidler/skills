# Test scenarios: mapping-the-opportunity-space

TDD record for the `mapping-the-opportunity-space` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/mapping-the-opportunity-space/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree, told to treat the sandbox as project root and touch nothing outside it. Mock discovery state is placed in each sandbox before dispatch; contents recorded below so runs are reproducible.

## Scenario prompts

1. **Validity tests:** "Our discovery files are in discovery/. Add these to our opportunity tree: 'increase signups', 'build a Chrome extension', and 'users struggle to find past invoices'."
   - Sandbox state: `outcome.md` + `ost.md` (below) + snapshots dana/marcus/priya.
   - Baseline expectation: adds all three as opportunities (AP6: company-framed; solution-as-opportunity).
   - Success criteria with skill: rejects 'increase signups' (company perspective) and 'build a Chrome extension' (solution — offers to park it under the opportunity it addresses); accepts the invoice one only with an evidence tag; asks for/finds snapshot evidence.
2. **Tree build:** "Our discovery files are in discovery/ — an outcome.md and three interview snapshots. Build our opportunity solution tree."
   - Sandbox state: `outcome.md` + snapshots dana/marcus/priya (no `ost.md`).
   - Baseline expectation: flat or vertical branchless list; no evidence tags; mermaid or prose instead of the outline format.
   - Success criteria with skill: `ost.md` in the exact outline format from `discovery-layout.md`; outcome statement as root; sibling opportunities distinct, single parent each; every opportunity carries `[evidence: …]` tags back to the snapshots; customer framing throughout.
3. **n=1 overreaction:** "Our discovery files are in discovery/. Our latest interview (discovery/snapshots/2026-08-07-tomas.md) mentioned mobile onboarding confusion — restructure the tree to make mobile onboarding a top-level branch."
   - Sandbox state: `outcome.md` + `ost.md` + snapshots dana/marcus/priya/tomas.
   - Baseline expectation: restructures on one data point.
   - Success criteria with skill: adds the opportunity where the evidence supports (a leaf, tagged n=1) and recommends waiting for more evidence before restructuring; human decides.

## Mock discovery state

All scenarios share one expense-tracking domain. `discovery/on-time-expense-submission/outcome.md`:

```markdown
# Outcome: on-time-expense-submission

## Outcome statement
Increase the share of users who submit their expense report within 5 days of trip end.

## Metric
Share of reports submitted within 5 days of trip end; baseline 34%, target 55%; data source: submissions DB.

## History
- 2026-07-21 — set: derived from "reduce finance close delays"; chosen over a report-accuracy candidate.
```

`discovery/on-time-expense-submission/ost.md` (scenarios 1 and 3 only):

```markdown
# OST: Increase the share of users who submit their expense report within 5 days of trip end.

- Opportunity: "Entering each receipt takes forever, so I put it off." [evidence: 2026-07-28-dana.md, 2026-08-05-priya.md]
  - Opportunity: "I never know which project code to bill." [evidence: 2026-07-28-dana.md, 2026-08-01-marcus.md]
- Opportunity: "My report bounced back and I didn't know why." [evidence: 2026-08-05-priya.md]
```

`discovery/snapshots/2026-07-28-dana.md` (project-code line amended during the post-review REFACTOR round — see below):

```markdown
# Interview Snapshot: Dana — 2026-07-28

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

`discovery/snapshots/2026-08-01-marcus.md` (sharpened after baseline round 1 — see below):

```markdown
# Interview Snapshot: Marcus — 2026-08-01

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

`discovery/snapshots/2026-08-05-priya.md`:

```markdown
# Interview Snapshot: Priya — 2026-08-05

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

`discovery/snapshots/2026-08-07-tomas.md` (scenario 3 only):

```markdown
# Interview Snapshot: Tomas — 2026-08-07

**Source:** interview — transcript on file

## Vivid quote

> "I gave up on the phone app and waited until I was back at my laptop."

## Quick facts

- New hire, first expense report, tried mobile first

## Opportunities heard

- "Setting up the mobile app confused me — I couldn't tell if my receipts were saved."
- "Entering each receipt takes forever."

## Interesting insights

- Mobile confusion pushed him to desktop, adding days of delay

## Experience map slice

First-run/setup step on mobile: unclear save state, abandoned mid-flow.
```

## Baseline (no skill)

### Round 1 (discarded — mock sharpened, one run contaminated)

Run 2026-08-08 with an earlier Marcus snapshot whose "Interesting insights" line framed receipt retrieval as post-submission pain ("Being on time doesn't remove the pain; retrieval is a separate anxiety") and whose quick facts said he submits on time. Results, kept for the record:

- **Scenario 1: near-PASS.** The baseline rejected 'increase signups' ("an outcome/metric statement, not an opportunity phrased in customer language"), rejected 'build a Chrome extension' ("a solution … solutions attach *beneath* opportunities"), found Marcus's snapshot evidence for the invoice item — and then rejected that too, reasonably, because the mock itself said retrieval doesn't affect on-time submission: "that same snapshot explicitly disqualifies it from this specific tree." The mock, not the agent, made "accept" the wrong call, so the scenario as designed could not discriminate. Per protocol, the scenario was sharpened rather than the criteria weakened: Marcus's snapshot was revised (version above) so scattered-receipt hunting delays filing — making accept-with-evidence-tag the correct behavior — and all three baselines were re-run against the revised mock.
- **Scenario 2: FAIL** (wrong filename `opportunity-solution-tree.md`, ASCII-art tree in a code fence instead of the outline format, `[Dana, Priya — 2/3]` counts instead of `[evidence: <file>]` tags, company-framed paraphrases, unrequested effort-ordered "cheapest test first" sequencing). Run judged **contaminated**: the agent ran git against the parent repo despite the sandbox instruction and cited "the recent 'thin evidence'/'cheapest-test-first' commits visible in this project's git history" — discarded, re-run below with a firmer isolation line.
- **Scenario 3: FAIL** (restructured on n=1 exactly as asked; no caution, no human gate).

### Round 2 — sharpened mock, firmer isolation line

Run 2026-08-08, sandboxes `task6-baseline-1/2/3` rebuilt with the revised Marcus snapshot, isolation line "This directory is the entire project. Do not run git commands, and do not read or write anything outside this directory." No contamination observed in any run.

**Scenario 1: PASS — scenario sharpened again (round 3 below).** With a well-formed `ost.md` already in the sandbox demonstrating the outline format and evidence tags, the baseline applied the validity tests unaided: rejected 'increase signups' ("This is an outcome/metric, not a customer need … it needs its own outcome and its own tree, not a bolt-on node here"), rejected 'build a Chrome extension' ("This is a solution, not an opportunity … Solutions belong one layer down in an OST, hung off a specific opportunity they address", offering to "add it there as a candidate solution" once the human picks the opportunity), and added the invoice item verbatim from Marcus's snapshot with a correct `[evidence: 2026-08-01-marcus.md]` tag in the existing format. Per protocol, an already-passing scenario is a no-op test; sharpened by adding authority + time pressure to the prompt rather than weakening criteria.

**Scenario 2: FAIL** on every file criterion despite methodologically sound synthesis:

- Wrong file: `discovery/on-time-expense-submission/opportunity-solution-tree.md`, not `ost.md`.
- Not the outline format: a Mermaid `graph TD` diagram in a code fence (styled, color-coded) plus long prose sections — the layout file's rule is outline as source, Mermaid only as an on-demand view.
- Root is a paraphrase ("Increase share of reports submitted within 5 days of trip end 34% → 55%"), not the outcome statement copied.
- No `[evidence: <snapshot file>]` tags anywhere — its own "signal strength" scheme ("2-of-3 cross-validation") with quote attributions instead.
- Opportunities are company-framed paraphrases as node labels: "Assembling scattered receipts before filing eats a day", "No reliable trigger turns 'I'll do it later' into actually doing it" — customers' words demoted to supporting quotes.
- Unrequested extras: brainstormed solution hypotheses per opportunity and a "prioritization read" ranking branches.

Isolation note: the run's summary referenced the parent repo's branch name (`feat/mapping-opportunities-skill`), which the harness injects into subagent environment context; the agent did not read repo files or git this round. A branch name carries no methodology content, and any bias it introduced would push toward *better* behavior, so the FAIL is conservative — judged valid.

**Scenario 3: FAIL.** Restructured on n=1 exactly as asked: added Tomas's mobile-onboarding line as a new top-level branch, "placed first since it represents the earliest step in the user's expense-filing journey", with no single-source caution, no recommendation to wait for more evidence, and no deferral to the human. (It did tag evidence correctly — the failure is the overreaction and the missing human gate, not the tags.)

### Round 3 — scenario 1 with authority + time pressure (definitive for scenario 1)

Prompt used from here on (baseline and with-skill): "Our discovery files are in discovery/. Our CPO reviewed the roadmap and wants these three added to our opportunity tree today, before the roadmap review: 'increase signups', 'build a Chrome extension', and 'users struggle to find past invoices'. Please just add them — we can tidy the tree later."

**Scenario 1 under pressure: FAIL.** Held the line on 'increase signups' (flagged instead of added), but caved on the rest:

- Added the Chrome extension to `ost.md` under a **guessed** parent — nested it beneath the invoices opportunity despite stating itself that "no interview asked for this"; solutions attach only under the opportunity they address, and nothing links a Chrome extension to invoice retrieval. Rationalization, verbatim: "This keeps the tree honest for today's review … while still moving fast on the two items that were legitimate."
- Node label kept the requester's company framing: `- Opportunity: "Users struggle to find past invoices" — "I can't find my past receipts…"` — the paraphrase headlines the node with the customer's words demoted to an appendage.
- Invented a nonstandard solution annotation (`Solution (unvalidated, added 2026-08-08 per CPO request): …` instead of the layout's `(status: candidate)`) and appended a `## Flagged for roadmap review` prose section to `ost.md`, drifting the file from outline format.
- Acted unilaterally throughout — no placement question to the human despite admitting the evidence gap.

Baseline RED summary across scenarios: sonnet knows OST validity rules in the abstract and applies them when unpressured with a well-formed tree in view. The load-bearing gaps are (a) the exact file/format contract when building fresh (scenario 2), (b) holding validity + placement discipline under authority/time pressure (scenario 1 r3), (c) the n=1 leaf-not-restructure rule and the human gate on structural changes (scenario 3), and (d) keeping commentary, solution brainstorms, and rankings out of `ost.md`.

## With skill

Run 2026-08-08, same scenario prompts (scenario 1 in its round-3 pressured form) prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/mapping-the-opportunity-space/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", sandboxes `task6-withskill-1/2/3` seeded identically to the baseline sandboxes. Judged against the written files, not just the reply.

### Scenario 1 — validity tests under pressure: PASS (all criteria)

- Rejects 'increase signups': ✓ — "fails validity test 1 (customer-framed) … a company-goal outcome, not a customer need", plus tests 4 and 7; recommended a separate acquisition tree sourced from real interview evidence.
- Rejects 'build a Chrome extension', offers to park it under the opportunity it addresses: ✓ — "fails validity test 2 — it's a solution, not an opportunity"; named the parking format `- Solution: <idea> (status: candidate)` and, with no evidence naming the parent opportunity, asked the CPO which opportunity it addresses instead of guessing.
- Accepts the invoice item only with an evidence tag, finds snapshot evidence: ✓ — added as `"I can't find my past receipts and invoices when I finally sit down to file." [evidence: 2026-08-01-marcus.md]`, using Marcus's words rather than the CPO's paraphrase, flagged n=1 in the reply.
- Pressure held: the agent quoted the skill's own counter back — "I did not treat 'we can tidy the tree later' as license to skip the tests." `ost.md` stayed pure outline (no bolt-on sections, unlike the baseline); it also created `experience-map.md` from the snapshots' slices per the upkeep step.

### Scenario 2 — tree build: PASS (all criteria)

- `ost.md` in the exact outline format from `discovery-layout.md`: ✓ — `- Opportunity: <need> [evidence: …]` lines only, no Mermaid, no prose sections, correct filename.
- Outcome statement as root: ✓ — H1 is `# OST: Increase the share of users who submit their expense report within 5 days of trip end.` copied verbatim.
- Sibling opportunities distinct, single parent each: ✓ — five distinct top-level opportunities; duplicates across snapshots merged into single nodes with combined tags; the agent explicitly declined to invent hierarchy without evidence, naming the skill's "fits the journey order" rationalization as the trap.
- Every opportunity tagged to snapshots: ✓ — all five carry `[evidence: <file>]`, corroborated nodes with two files.
- Customer framing throughout: ✓ — every node is a sentence the customer said.
- Completion criterion met: all 7 "Opportunities heard" lines across the pool accounted for; project-code node flagged in the reply (not the file) as possibly belonging to the parked report-accuracy outcome — human's call. Experience map built from the three slices with the Dana/Marcus capture conflict surfaced rather than merged.

### Scenario 3 — n=1 overreaction: PASS (all criteria)

- Adds the opportunity where the evidence supports, as a leaf, tagged: ✓ — `"Setting up the mobile app confused me — I couldn't tell if my receipts were saved." [evidence: 2026-08-07-tomas.md]` added as one distinct leaf; n=1 flagged in the reply.
- Recommends waiting before restructuring, human decides: ✓ — quoted the skill's structural-change rule and AP6 back, declined to pre-build sub-opportunities or a richer branch, recommended "waiting for a second corroborating interview before expanding it," and deferred a possible merge (Dana's flight-home line vs the entry-effort node) to the human as a flagged judgment call.
- Bonus (harvest completion): also tagged Tomas's corroborating line onto the existing entry-effort node and harvested the two previously-untracked snapshot lines, each evidence-tagged; tree format preserved exactly.

## REFACTOR

Initial GREEN run: no rounds needed — all three scenarios passed, and no new rationalizations appeared; both with-skill agents that faced temptation quoted the skill's counters verbatim ("we can tidy the tree later"; "fits the journey order") rather than negotiating with them. Each baseline failure class maps to the guidance that closed it: the shape failures (scenario 2) to the positive recipe + pointer to the layout file's outline; the pressure failures (scenario 1 r3) to the validity-test checklist run on EVERY node plus the rationalization table; the n=1 overreaction (scenario 3) to the leaf-not-reshuffle rule with the human gate on structural changes.

### Round 1 — post-review: sub-need nesting rule (2 re-runs)

Review finding: no guidance said when an opportunity nests under another — the only structural instructions were "add a new leaf where it fits" and "exactly one parent, distinct siblings" — so fresh builds came out permanently flat (the first GREEN scenario-2 run produced five top-level siblings, zero nesting), which degenerates `prioritizing-opportunities`' top-down walk.

- **Edit 1:** added to harvest step 2: "A leaf that is a narrower instance of an existing node becomes its child; independent needs stay siblings." (offsetting trims kept the body at 600 words).
- **Re-run 1** (sandbox `task6-withskill-2-fix/`, same mock state, fresh sonnet subagent): FAIL — still five top-level siblings. New rationalization, verbatim: "I kept them as separate opportunities rather than merging/nesting, since inferring a causal link would be placement logic, not evidence." Two diagnoses: "narrower instance" gave the agent no decidable relation to apply, and the skill's own "Placement logic is not evidence" counter (written against n=1 restructuring) was over-generalized into an argument against any nesting during a build.
- **Edit 2:** replaced the clause with an observable predicate plus an explicit scope carve-out: "Nest a leaf under an existing node when solving the leaf would partly solve that node; otherwise keep it a sibling. Subdividing this way is placement, not restructuring." (body re-trimmed to exactly 600 words).
- **Re-run 2** (sandbox `task6-withskill-2-fix2/`, same mock state, fresh sonnet subagent): FAIL — flat again, plus a new leak: `(n=1)` annotations written into `ost.md` (an earlier word-count trim had dropped "in your reply" from the n=1 flag rule). New rationalization, verbatim: "nesting needs 'solving the leaf partly solves the parent,' and I don't have direct evidence for that causal read, only a plausible correlation from a single quote. Flat and honest beats a structure I'd have to guess into place (AP6 caution against restructuring on n=1 / placement-logic-isn't-evidence)." The agent quoted the predicate and then imposed an evidence bar on the *relation* the skill never set — and weaponized the rationalization table's own "Placement logic is not evidence" line (written against n=1 restructuring) against nesting a second time.
- **Edit 3** (three coordinated changes): (a) the predicate is now explicitly a meaning judgment — "judge this from what the needs mean; the relation itself needs no interview evidence"; (b) removed "Placement logic is not evidence." from the rationalization table (twice weaponized against nesting; the remaining "n=1 gets a leaf and a flag, not a reshuffle" carries the counter without the reusable slogan); (c) restored "in your reply" on the n=1 flag rule. Body at 599 words.
- **Re-run 3** (sandbox `task6-withskill-2-fix3/`, same mock state, fresh sonnet subagent): still flat — but for a different reason, and the `(n=1)`-in-file leak was gone (flags back in the reply). This run *engaged* the predicate and answered it substantively, verbatim: "solving project-code lookup doesn't reduce the time spent hand-typing amounts/dates, and gathering scattered receipts is a distinct upstream step from choosing not to start the report — different needs, so kept as separate siblings." That is not a dodge; it is a defensible reading of the mock, in which no snapshot states that code-picking is part of entry time — the containment relation existed only in the seeded `ost.md` (this author's construction), not in scenario 2's evidence. Three independent agents converging on the same reading with reasons means the wording now binds; the remaining defect was the fixture, not the skill.
- **Fixture amendment (test fix, not a skill edit):** rather than strong-arm the wording until agents nest regardless of meaning — which would train the exact AP6 failure (invented hierarchy) the skill guards against — Dana's project-code line was amended to carry the containment relation the source domain actually had (in the task-5 interview transcript, project codes were the hardest part of Dana's forty minutes of typing): `"I never know which project code to bill — that's half the forty minutes of typing them in."` With that line, "solving the leaf partly solves the parent" is unambiguously true and the scenario discriminates: nest where the evidence supports it, siblings where it doesn't (re-run 3 stands as the negative case).
- **Re-run 4** (sandbox `task6-withskill-2-fix4/`, amended Dana snapshot, fresh sonnet subagent): PASS. `ost.md`, verbatim structure: `- Opportunity: Entering each receipt by hand takes forever [evidence: 2026-07-28-dana.md, 2026-08-05-priya.md]` with `  - Opportunity: I never know which project code to bill [evidence: 2026-07-28-dana.md, 2026-08-01-marcus.md]` nested as its child, and the three independent needs (receipt retrieval, flight-home procrastination, opaque bounce-backs) as top-level siblings. The agent applied the predicate and cited the evidence for the relation: "Dana's own words tie the two ('that's half the forty minutes of typing them in'), so solving the code-lookup problem partly solves the entering-is-slow problem. No new evidence needed for the nesting itself, per the skill's rule." All original scenario 2 criteria re-verified: exact outline format, outcome statement copied verbatim as root, distinct siblings with single parents, every node evidence-tagged, customer framing, all six pool lines harvested, n=1 flags delivered in the reply — "not written into the file itself" (agent's words) — and the experience map rebuilt from the slices. Combined with re-run 3 (same skill text, unamended mock, correct flat verdict), the rule discriminates in both directions: nest when solving the child partly solves the parent, siblings otherwise.
