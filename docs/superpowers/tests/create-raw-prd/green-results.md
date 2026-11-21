# One-page PRD — GREEN results

Each scenario from `scenarios.md`, run on the changed skill (`product-development`
0.12.0). Run 2026-11-20. Grader: the main session, with `check.sh` for the counts and a
read of each page for the kept facts.

## S1 — rich grilling (1,323 words in)

**5/5 PASS.** Baseline was 0/5.

| Rep | Page words | Baseline | R | A | Q | Kept facts | Build ideas on page | Reply |
|---|---|---|---|---|---|---|---|---|
| 1 | 500 | 1,367 | 9 | 2 | 4 | all | none | question, 18 items |
| 2 | 500 | 1,369 | 9 | 2 | 4 | all | none | question, 21 items |
| 3 | 500 | 1,356 | 10 | 2 | 4 | all | none | question, 21 items |
| 4 | 500 | 1,416 | 9 | 2 | 4 | all | none | question, 20 items |
| 5 | 499 | 1,376 | 10 | 2 | 4 | all | none | question, 17 items |

- **Kept facts** (item 3): the main metric with its date, zero breaches, the four rules,
  no override, the 12-hour cut-off, the two-year record, and four `Q` items each naming
  Priya, Tom or Mei are on the page in every rep.
- **Requirements went from 15 to 9 or 10 by merging, not dropping.** Offer, notify and
  accept became one or two `R` items; the four rules and "no override" became one. Reps 3
  and 4 put sickness and holiday on one non-goal line; both still carry the reason.
- **The question** (item 5) has the same shape in all 5: the list, a note that the build
  ideas are not in it, then the two options in the skill's words.
- **What the page left off, in every rep:** the Leeds anecdote, where the 60-a-week figure
  came from, the five status names, the role examples ("an opening shift needs a
  keyholder" is on the page in rep 4 only), and the user's own phrasing of the risks. Each
  one is in the question's list, so the user sees it before it is cut.

## S1-cut — the user answers "Cut it"

**2/2 PASS** (reps 1 and 5). The file is byte-identical to the file before the answer.
The reply is the hand-off message.

## S1-appendix — the user answers "Appendix"

**4/4 PASS.**

- Reps 2 and 4, with the first wording (a `---` line, then the heading): the page is
  byte-identical and 500 words. Below it is `## Appendix: left off the page` with the same
  numbered list the question showed (797 and 810 words in the whole file).
- 2 more reps after the `---` line was dropped from the skill, started at step 5 on
  `fixtures/C1-prd.md`: the page is byte-identical and 500 words, the appendix sits under
  the heading alone (737 and 789 words in the whole file), and the reply is the hand-off
  message. The heading alone now marks where the page ends.

## S3 — thin grilling (225 words in)

**3/3 PASS.**

| Rep | Page words | Baseline | Reply |
|---|---|---|---|
| 1 | 205 | 272 | hand-off, no question |
| 2 | 229 | 266 | hand-off, no question |
| 3 | 206 | 272 (max) | hand-off, no question |

The limit did not become a target: each page is shorter than the baseline's, and nothing
was added. With nothing left off the page, no rep asked the question.

## Observed, not fixed

- **The write step is slower.** S1 runs took 170–351 seconds and 12–20 tool calls, against
  55–75 seconds and 4 at baseline. The time goes on the `wc -w` loop: the first draft lands
  near 550 words and is trimmed a few words at a time until it prints 500.
- **Rich pages land on the limit exactly** (500, 500, 500, 500, 499). Rep 5 dropped the
  `-` list markers to save words, since `wc -w` counts each one. The template has no list
  markers, so the page still matches it.
- **The question is long for a rich grilling:** 17–21 one-line items, about 250 words.
- **"So that" clauses get thin under the limit**, for example "so that one accepts" and
  "so that I work it". The template's user-story form costs about 8 words an item.

## critique-prd

The final change to `critique-prd` is one paragraph: what the appendix is, and how to read
it. Getting there took four wordings. Each was run against the baseline in
`baseline-results.md` (C1: 657–688 words after the fixes; C2: 713–770, with 3–6 appendix
lines moved above the heading).

| Wording | What it said | Result |
|---|---|---|
| 1 | Appendix is the owner's words. After the fixes, shorten the page back to 500 and list what left it. | Page held at 500 in 6/6. **Rejected:** what left the page was the agent's choice (a goal or non-goal in 5/6), one rep cut its new `Q` items to fragments, and findings fell to 7–12 against 11–18. |
| 2 | As 1, but lines leave in a fixed order (repeated Problem numbers, then Risks, then Non-goals), with a table row against raising fewer findings. | 14 findings, so the row worked. **Rejected:** the fixes took the page from 500 to 715; every Risks and Non-goals line left and the page still ended at 616. One rep finished; five were cut off by a usage limit with pages at 553–681. |
| 3 | No limit in `critique-prd`. Appendix text "can go into an edit". | 16, 18, 19 findings; appendix unchanged in 3/3. **Rejected:** each rep copied 5–6 appendix items above the heading, and the pages ended at 755–829, longer than the baseline. |
| 4 (final) | No limit. "The spec writer reads the appendix too… a question it answers is not a gap." | Below. |

A full critique of a full page adds 150 to 220 words, mostly new `Q` items. Risks, Non-goals
and repeated numbers hold about 100 words, so a page that keeps its goals, requirements and
open questions cannot also stay at 500. The owner chose to limit the raw draft only.

### C2, final wording — critique only

**2/2 PASS**, a third rep void (cut off three times when the machine slept).

| Rep | Findings | Appendix line as a finding's location | Appendix items copied above the heading | Left alone because the appendix answers it |
|---|---|---|---|---|
| 1 | 19 | none | none | 5 listed |
| 3 | 12 | none | none | 11 listed |

- Both reps kept the two BLOCKERs the baseline also found (how a swap's return shift is
  chosen; whether a late change by phone goes into the product).
- Rep 3: "**Answered by the appendix:** Definition of "uncovered shift" (appendix 2)… The
  R5 statuses (appendix 8)…". Rep 1: "**Traced by the Appendix:** the 60 a week (Appendix
  3), the meaning of "uncovered" (Appendix 2)…".
- One edit in each rep adds a Users line for Head of Operations and names appendix 20
  beside R9 as its source. R9 already names that user, so this is not appendix detail
  moving up.

### K1 — critique only, no appendix (wording 1, which had the limit)

**PASS.** Baseline: 20, 23, 24 findings. Changed skill: 18, 22, 23. The critic that
`/create-prd` dispatches did not raise fewer findings even with the limit in the skill;
the drop in wording 1 came only when one agent both critiqued and fixed.

## Not tested

- The final wording with the fixes applied. The apply step is unchanged from the baseline,
  and wording 3, which differs by one clause, left the appendix unchanged in 3/3.
- A third rep of the final wording.
- The length of a PRD after `critique-prd` when the owner answers the decisions. Every C
  run answered "not now".
