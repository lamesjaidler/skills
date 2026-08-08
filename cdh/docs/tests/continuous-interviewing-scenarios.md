# Test scenarios: continuous-interviewing

TDD record for the `continuous-interviewing` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/continuous-interviewing/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree.

## Scenario prompts

1. **Guide prep:** "Write me 8 interview questions to find out what features users want next in our expense-tracking app."
   - Baseline expectation: speculative/preference questions ("What features would you like?") — AP1.
   - Success criteria with skill: story-based questions ("Tell me about the last time you…"); anchored to experience-map slices; no prediction or preference questions; excludes live-interview coaching (out of scope, stated).
2. **Snapshot synthesis:** the prompt below, verbatim (mock transcript composed for this test — reproduce exactly for re-runs):

   > Here's this morning's interview transcript — summarize it for the team:
   >
   > Interviewer: Thanks for making time, Dana. Can you tell me about the last time you filed an expense report?
   > Dana: Ugh, okay. Last month, after the Denver trip. I filed it eleven days late and my manager pinged me twice about it.
   > Interviewer: Walk me through what happened.
   > Dana: The trip itself was fine, but the receipts pile up — hotel, taxis, three client dinners. I always mean to do the report on the flight home and never do.
   > Interviewer: What did you do with the receipts in the meantime?
   > Dana: I photograph every receipt the moment I get it and dump the photos into a personal album on my phone called "Expenses ugh". The paper ones I throw away — they just die in my bag otherwise.
   > Interviewer: And then what happened?
   > Dana: Sunday night, eleven days later, I sat down with the album and typed each one into the app. Forty minutes, maybe more.
   > Interviewer: What was the hardest part of those forty minutes?
   > Dana: Honestly? The project codes. I never know which project code to bill. There are like sixty of them and the names are all acronyms, so I ended up Slacking our finance person. Again.
   > Interviewer: What happened after you submitted?
   > Dana: It bounced back once because I'd picked the wrong code for one of the dinners. Fixed it, resubmitted, got reimbursed about a week later.
   > Interviewer: Have you tried anything to make this easier?
   > Dana: The album is my system. A coworker swears by some scanning app but I never set it up. Honestly I'd pay for anything that fills the form for me — typing amounts off photos at 10pm is the worst part of my job, and it isn't even my job.

   - Baseline expectation: generic prose summary or raw-notes dump (AP11); opportunities restated in company framing.
   - Success criteria with skill: produces a snapshot at `discovery/snapshots/<date>-dana.md` using the template's exact sections; "Opportunities heard" in Dana's words; vivid quote chosen; source-tagged.

## Baseline (no skill)

Run 2026-08-08, scratchpad sandboxes `task5-baseline-1/` / `-2/` (outside the repo tree), general-purpose subagents on sonnet, prompt = scenario prompt plus sandbox-isolation instruction only. Isolation note: the user-level CLAUDE.md injected into every session mentions that a `qualitative-product-research` plugin exists elsewhere (baseline 1's closing sentence references it), but it contains no interviewing methodology, no Torres content, and nothing about the skill under test — both runs judged valid.

### Scenario 1 — guide prep: FAILED (partial — avoids the crudest AP1, still mixes in prediction/preference questions; no map anchoring; includes live coaching)

Better than the crude expectation: the agent explicitly avoided "what features do you want" ("avoiding leading questions", "people are bad at answering directly") and Q1/Q3 are genuine story questions ("Walk me through the last time you logged an expense…"). Failures against the success criteria:

- Prediction/preference questions present — Q4: "If you had to give up the app tomorrow, what would you miss most…?"; Q6: comparative preference ("Think of another app… that handles something really well"); Q8, verbatim: "If you could wave a magic wand and change one thing about how you track expenses, what would it be — and why does that matter to you?" rationalized as "Open-ended prioritization question; the 'why' surfaces the underlying job-to-be-done, not just a surface-level feature request."
- No anchoring to an experience map or any model of the current customer experience — questions are free-floating over the whole product.
- Included live-interview coaching rather than excluding it: "Follow every answer with 'why' or 'tell me more'", ordering advice ("Ask questions 1–3 before 4–8"), and an offer to run interviews "formally".
- No follow-up timeline scaffolds attached to the story questions.

Takeaway for GREEN: sonnet already knows "don't ask what do you want" in the abstract — the load-bearing guidance is (a) the *every*-question bar (no magic-wand/miss-most/comparison escapes), (b) anchoring questions to experience-map slices, (c) timeline follow-up scaffolds, (d) stating live coaching out of scope.

### Scenario 2 — snapshot synthesis: FAILED (structured notes dump, company-framed opportunities, no file, no template)

Produced a long chat-message summary ("## Summary: Dana — Expense Reporting Interview") with sections What happens today / Pain points ranked / Workarounds tried / Notable verbatim / Possible opportunity areas. Failures against the success criteria:

- No file written at `discovery/snapshots/<date>-dana.md`; output exists only in the reply.
- Not the snapshot template: none of Vivid quote / Quick facts / Opportunities heard / Interesting insights / Experience map slice; instead a multi-section notes dump — the AP11 shape (detailed notes shared, not a one-page snapshot).
- Opportunities restated in company/solution framing, verbatim: "Auto-extraction from receipt photos (OCR/line-item fill)", "Smarter/assisted project-code selection (search, recent-codes, suggestions based on trip/vendor)". Dana's words appear only as decorative "Notable verbatim" quotes below the ranked pain list.
- No source tag.

Partial credit: it did preserve two verbatim quotes and flagged n=1 caution. The gap is entirely shape and framing — file path, exact template sections, opportunities in the customer's words, source tag.

## With skill

Run 2026-08-08, same scenario prompts prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/continuous-interviewing/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", scratchpad sandboxes `task5-withskill-1/` / `-2/`. Judged against the written files, not just the reply.

### Scenario 1 — guide prep: PASS (all criteria)

Recognized prep mode and explicitly redirected the "what features do users want" framing as AP1 ("collects unreliable predictions, not evidence"). Wrote `discovery/expense-capture-experience/experience-map.md` (drafted, flagged as an assumption needing the user's correction) and `discussion-guide.md`.

- Story-based questions: all 8 are "Tell me about the last time you…" past-instance questions, each with three timeline follow-up scaffolds ("Take me back to the start", "What happened next?", "What did you do then?"). ✓
- Anchored to experience-map slices: map drafted first (8 steps), slice picked and named in the guide header ("Steps 2–3 — capture/log and categorize/code") with a why. ✓
- No prediction or preference questions: checked every question and scaffold in the file — zero would-you/magic-wand/miss-most/comparison questions; the baseline's Q4/Q6/Q8 shapes are absent, and the guide carries the skill's counter for the interviewer ("don't ask what people want… that collects opinion, not behavior"). ✓
- Live coaching excluded, out of scope stated: guide scope note verbatim — "It does not cover how to steer or improvise the live conversation… this skill is prep-and-synthesis only, not live copilot." No coaching content included. ✓

### Scenario 2 — snapshot synthesis: PASS (all criteria)

Wrote `discovery/snapshots/2026-08-08-dana.md` plus the raw transcript at `discovery/raw-transcripts/2026-08-08-dana.md` kept for provenance and linked from the Source line (not shared — agent cited AP11 for the distinction; extra file judged harmless, not a criterion).

- Snapshot at `discovery/snapshots/<date>-dana.md`: ✓ (today's date, pseudonym).
- Template's exact sections: Vivid quote / Quick facts / Opportunities heard / Interesting insights / Experience map slice, exact headings, comments preserved, Source line present. ✓
- Opportunities heard in Dana's words: all five are verbatim quotes ("I never know which project code to bill.", "I always mean to do the report on the flight home and never do." …); the transcript's implied feature ideas were kept out — the auto-fill wish is explicitly flagged in Insights as "a solution-space statement rather than an opportunity itself." ✓
- Vivid quote chosen: the pay-for-anything/10pm line. ✓
- Source-tagged: "**Source:** interview — [raw transcript](../raw-transcripts/2026-08-08-dana.md)". ✓

Bonus: with no experience map on disk, the Experience map slice section says so and reconstructs the slice from the interview with an n=1 caution rather than inventing an established map.

## REFACTOR

No rounds needed: both scenarios passed on the first GREEN run with no new rationalizations to counter. The baseline's specific escapes (magic-wand/miss-most/comparison questions; notes-dump summary; company-framed opportunity lists) did not recur — each is addressed by a positive completion criterion in the skill ("zero questions ask the participant to predict, choose, rank, imagine, wish, or compare"; "every opportunity reads as a sentence the participant could have said") rather than a prohibition list, per the shaping-failure form rules.
