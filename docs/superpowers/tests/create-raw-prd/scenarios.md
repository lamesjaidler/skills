# One-page PRD test scenarios

Scenarios for the one-page rule in `product-development/skills/create-raw-prd` (S
scenarios) and for how `critique-prd` treats a one-page PRD and its appendix (C
scenarios), per `superpowers:writing-skills`. Fixtures are fictional and live in
`fixtures/`.

The grilling itself needs a live user, so each scenario starts after it: the fixture is a
finished grilling transcript, and the subagent writes the PRD from it.

## How a scenario is run

For each run, `SCN=<scratchpad>/scn-<id>-<arm>-<rep>`:

1. `mkdir -p $SCN/docs/prd && cp -R product-development/skills $SCN/skills`
2. `cp fixtures/<id>-transcript.md $SCN/transcript.md`
3. Baseline arm: the skill as it was before the change. With-skill arm: the changed skill.
4. Dispatch a fresh `general-purpose` subagent with the prompt below, `$SCN` and `<slug>`
   filled in.
5. `bash check.sh $SCN/docs/prd/<slug>.md`, then read the PRD and grade it against the
   scenario's **Pass if** list.

**Prompt:**

> You are midway through a `/create-raw-prd` session. SCN=`$SCN`
>
> Read `$SCN/skills/create-raw-prd/SKILL.md`. Steps 1–3 are already done: the full grilling
> is in `$SCN/transcript.md`, and the user confirmed shared understanding. Carry on from
> step 4 to the end of the skill. Write the PRD to `$SCN/docs/prd/<slug>.md`.
>
> Read and write only files under `$SCN`. You can't reach the user: when a step has you ask
> the user something, stop there and reply with the exact question you would ask. Otherwise
> your reply is the hand-off message and nothing else.

The baseline runs used the same prompt without the "can't reach the user" sentence, and
"Do steps 4 and 5 now" for "Carry on from step 4 to the end of the skill": the old skill
had no step that asks.

The continued scenarios (S1-cut, S1-appendix) copy the PRD aside first, then send the same
subagent: "The user answered your question: "<answer>". Carry on with the skill from there
to its end." Compare the file with the copy afterwards.

**The page** is the file's text above the appendix (its `---` line and `## Appendix`
heading), or the whole file when there is none. `check.sh` prints its word count as
`page=`.

## Scenarios

| Id | Fixture | Pass if |
|---|---|---|
| S1 | `S1-transcript.md`: Shiftswap, a rich grilling (1,323 words; 4 user types, 5 metrics, 6 non-goals, 4 deferred decisions, a long anecdote, 3 volunteered build ideas). | 1. Page is 500 words or fewer. 2. All seven sections and the status line are present; `R`, `A`, `Q` items are numbered. 3. The page keeps: uncovered shifts 9 a month to 2 or fewer in three months; zero breaches; the four swap rules and no manager override; the 12-hour cut-off; the two-year audit record; four `Q` items each naming who (Priya twice, Tom, Mei); a reason on each non-goal. 4. No build idea on the page (rota tool API, WhatsApp bot, Firebase); all three are in the question or hand-off reply. 5. The reply is a question that lists what the page left off and offers two choices: cut it, or keep it in an appendix in the same file. |
| S1-cut | S1, continued: the user answers "Cut it". | The file is unchanged. The reply is the hand-off message. |
| S1-appendix | S1, continued: the user answers "Appendix". | The page is unchanged and still 500 words or fewer. Below it the file has the appendix, holding the listed leftovers. The reply is the hand-off message. |
| S3 | `S3-transcript.md`: Jotter pin, a thin grilling (225 words). | 1. Page is no longer than the baseline's (272 words): the limit is a ceiling, not a target. 2. Sections, status line and numbering as S1. 3. No question: the page holds everything, so the reply is the hand-off message. |

## critique-prd scenarios (C)

Each fixture is a 500-word page that a with-skill S1 run wrote. For each run:
`mkdir -p $SCN/docs/prd && cp -R product-development/skills $SCN/skills`, then
`cp fixtures/<id>-prd.md $SCN/docs/prd/shiftswap.md`. Baseline arm: `critique-prd` as it
was before the change. Dispatch a fresh `general-purpose` subagent with:

> SCN=`$SCN`
>
> Read `$SCN/skills/critique-prd/SKILL.md` and run that skill on
> `$SCN/docs/prd/shiftswap.md`. The request pre-authorizes fixes: critique it and fix all
> findings. The PRD owner answers "not now" to every owner decision. For any other question
> the skill has you ask the owner, stop and reply with the exact question. Otherwise apply
> the edits and reply with the skill's report.
>
> Read and write only files under `$SCN`. There is no code for this product and no
> grilling transcript.

"Not now" keeps every new `Q` in the PRD, so this is the case that grows the page most.

The one-page limit covers the raw draft only. `critique-prd` adds what it finds, so no C
scenario checks the page's length after the fixes; `green-results.md` records why.

| Id | Fixture | Pass if |
|---|---|---|
| C1 | `C1-prd.md`: one page, no appendix. | No pass list. It measures how far the fixes grow the page. |
| C2 | `C2-prd.md`: the same kind of page with a 20-item appendix. | 1. No finding has an appendix line as its location. 2. No appendix line becomes an `A` item, and the 20 appendix items are unchanged after the fixes. 3. Where the appendix backs a claim above it, the claim is treated as traced. |
| K1 | `C1-prd.md`, critique only, with the prompt `/create-prd` sends its critic: "…You are a subagent and no PRD owner is reachable: return the skill's full report and edit no files." | The changed skill raises no fewer findings than the baseline. |
