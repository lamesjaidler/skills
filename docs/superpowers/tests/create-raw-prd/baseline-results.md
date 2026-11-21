# One-page PRD — RED baseline results

Each scenario from `scenarios.md`, run on the skill as it was before the one-page change
(`product-development` 0.11.0). Run 2026-11-20. Grader: the main session.

## S1 — rich grilling (1,323 words in)

**0/5 PASS.** Every rep fails item 1 (page is 500 words or fewer) by a wide margin. The
PRD is longer than the grilling it was written from.

| Rep | Words | R | A | Q | Sections |
|---|---|---|---|---|---|
| 1 | 1,367 | 15 | 2 | 4 | all present |
| 2 | 1,369 | 14 | 2 | 4 | all present |
| 3 | 1,356 | 15 | 3 | 4 | all present |
| 4 | 1,416 | 15 | 2 | 4 | all present |
| 5 | 1,376 | 15 | 2 | 4 | all present |

The spread is 60 words: the skill as written reliably produces this length, so it is the
skill's shape and not chance.

Where the words go (rep 4; the others are within 40 words per section):

| Section | Words | What fills it |
|---|---|---|
| Requirements | 527 | 15 user stories at about 35 words each. The "so that" clause restates the problem each time. |
| Problem | 213 | The Leeds anecdote in full (all 5 reps), then the same numbers the Goals table repeats. |
| Goals & success metrics | 211 | A table with a written-out definition for each metric. |
| Non-goals | 135 | Each reason as two sentences. |
| Assumptions & open questions | 122 | Each `Q` restates the conversation around it. |
| Users | 97 | One user type per line, plus what they want (repeated in Requirements). |
| Risks | 80 | |

Items 2–4 pass in all 5 reps: sections, numbering, kept facts, and no build ideas on the
page. The failure is shape only. Nothing is wrong or missing; it is all there three times
over.

Failure type, per `writing-skills` "Match the Form to the Failure": the agent complies, but
the output has the wrong shape. Right form: say what the page is (a size, and what one
line holds). Wrong form: a list of things not to write.

## S3 — thin grilling (225 words in)

| Rep | Words | R | A | Q |
|---|---|---|---|---|
| 1 | 272 | 2 | 1 | 1 |
| 2 | 266 | 2 | 2 | 1 |

Already inside one page. S3 is a regression check for the change: a word limit must not
become a target that a thin PRD is padded up to.

## C1 — critique and fix a one-page PRD, no appendix

Run on `critique-prd` as it was at `product-development` 0.11.0. **0/3 PASS.** Every rep
fails item 1.

| Rep | Findings | Page before | Page after | A | Q |
|---|---|---|---|---|---|
| 1 | 11 | 500 | 657 | 2 → 3 | 4 → 9 |
| 2 | 12 | 500 | 688 | 2 → 6 | 4 → 9 |
| 3 | 16 | 500 | 688 | 2 → 6 | 4 → 12 |

Each rep saw the limit and said why it did not act on it:

- Rep 1: "`critique-prd` sets no word limit, but `create-raw-prd` caps a raw PRD at 500."
- Rep 2: "`critique-prd` sets no limit, so I did not trim."
- Rep 3: "`critique-prd` has no rule on length, so I cut no owner content to get back under
  it."

## C2 — critique and fix a one-page PRD with an appendix

**0/3 PASS.** Every rep fails item 1 and item 4.

| Rep | Findings | Page before | Page after | Appendix lines moved onto the page |
|---|---|---|---|---|
| 1 | 18 | 500 | 758 | 4 (one to Problem, three to new `A` items) |
| 2 | 18 | 500 | 770 | 6 (one to Problem, five to new `A` items) |
| 3 | 16 | 500 | 713 | 3 (one to Problem, two to new `A` items) |

The pages grow more than in C1 because the critic treats the appendix as PRD text to
critique. A line such as "Most swaps are really giveaways" becomes a finding ("a belief
with no source") whose edit moves it onto the page as an `A` item, so detail the owner
left off the page comes back. Rep 3 left "Moved to A4." in the appendix; reps 1 and 2
deleted the lines, and rep 1 left gaps in the appendix numbering.

Failure type for C2: the skill does not say what the appendix is. Right form: a statement
of what it is and how to read it. C1's growth was kept as a measure, not fixed: see
`green-results.md` for why the limit stays on the raw draft only.
