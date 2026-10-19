# improve-workflow — GREEN and REFACTOR results

The same scenarios as `baseline-results.md`, run with the skill. Reviewer scenarios use the
`SKILL.md` step 1 dispatch prompt verbatim; main-thread scenarios point the subagent at
`SKILL.md`. Grader: the main session, against each scenario's **Pass if** list.

## Summary

| Scenario | Baseline | GREEN round 1 | Round 2 (after REFACTOR) |
|---|---|---|---|
| R1 clean run | 1/3 | void (fixture gap, see below) | **3/3** |
| R2 silent drift + sound ruling | fail | **3/3** | — |
| R3 vague spec, blame upstream | fail | **3/3** | — |
| R4 user corrected twice | fail | **3/3** | — |
| M1 no findings | 3/3 | **3/3** | — |
| M2 drop / untested / already fixed | fail | **3/3** | 1/1 regression |
| M3 fix names the product | 3/3 | **3/3** | — |
| M4 where edits go | 3/3 | **3/3** | 1/1 regression |
| Late-slip testability (R1 old fixture) | — | 0/1 (loophole) | **1/1** |

Every baseline failure pattern is closed:

| Baseline pattern | With the skill |
|---|---|
| Sound ruling made a finding; redesign proposed (R1) | "The ruling … came with a reason at the time … nothing in the spec contradicts it" — 3/3 R1, and R2/R3 say the same of their rulings |
| Blame stops at skills in the transcript (R3) | "Blame: `critique-spec` … upstream. The gap was already in the spec before `/build-from-spec` started" — 3/3 |
| No testability judgement (R2, R4) | `Testable:` filled in every finding, every run |
| Long-run drift reported as tested (M2) | "F2: **untested** … A replay that passes would prove nothing, so I won't call it tested" — 4/4, even with the user asking for a test |
| Version bump / `CHANGELOG.md` on the fix branch (8 runs) | 0 runs. "Commit only `product-development/skills/build-from-spec/SKILL.md`. Leave `plugin.json` and `CHANGELOG.md` alone." |
| Second go-ahead asked before pushing (M2, M4) | "Don't ask again before pushing" — every M run that reaches step 5 |

## Round 1 notes

- **R1 void.** Reps 2 and 3 found a real gap the fixture still had: `update-pr` saved a title
  without its required `<Area>:` prefix, read 3 of its 9 `gh pr view` fields, didn't save the
  diff and didn't check `CONTEXT.md`. Those are correct findings by the guide. R1–R3 fixtures
  now run `update-pr`'s steps in full with area-prefixed titles; R1 was re-run in round 2.
  Rep 1 returned "No findings." Not one rep made the lowercasing ruling a finding.
- **R2 rep 2 and rep 1** also raised the spec's self-contradiction (§Storage names `orjson`,
  §Constraints forbids new dependencies) as an upstream `critique-spec` finding, while still
  saying the ruling itself is not a finding. The fixture does contain that gap, so this is
  correct. Rep 1 replaced product words with placeholders (`<the feature>`, `<command>`).
- **R4** reps each list 4–5 further skipped steps from the shortened fixture (template, invent
  check, fix flow, critic's severity scale). All are real in the fixture, all blamed on the
  right skill, all marked testable by replay. The user would pick from them.
- **Loophole (R1 rep 2):** marked a one-turn slip `Testable: no` because it happened "inline at
  the end of one long build run. A fresh replay … would not have the same context."
- **Gaps M4 found in the skill text (3/3):** `gh pr create` had no `--title` and fails
  non-interactively; the skill's path inside the worktree was never stated; step 5's
  repo-relative commands needed a `cd`; two runs on the same day would clash on the branch name.
- **Wording clashes M2 rep 3 found:** the "Editing before a test has failed" row read as
  banning the untested path; the opening said every fix is tested.

## REFACTOR

- `reviewing-a-run.md`: `Testable: no` is only for a problem built up across many turns or
  tasks; a slip in one turn or one subagent is `yes`, however late it came.
- `SKILL.md`:
  - opening: fixes are tested "where a faithful test exists";
  - step 3: names `product-development/skills/<skill>/` in the worktree, points RED/GREEN at
    the worktree's copy, branch and folder use `<YYYYMMDD-HHMM>`;
  - step 5: `cd <worktree>` first; `gh pr create … --title '<skill>: <what changes>'`; body
    file in the scratchpad;
  - Common mistakes: the RED-first row is scoped to `Testable: yes` findings.

## Round 2

- **R1 (fixed fixture), 3/3:** "No findings." each time; "The one ruling … came with a reason at
  the time … nothing in the spec contradicts it." Rep 3: the plan critique's own fix "is that
  step's job."
- **Late-slip check (old R1 fixture), 1/1:** the title slip is now "Testable: yes. Replay the
  conversation up to the `update-pr` call."
- **M4 regression, 1/1:** uses `cd`, `--title`, a scratchpad body file, the timestamped branch
  and the worktree skill path.
- **M2 regression, 1/1:** F1 dropped, F2 **untested** with the reason despite the user's ask, F3
  dropped; no version bump; no second go-ahead.

## Final-review fix pass

A fresh whole-branch reviewer returned "with fixes". Each Important finding got a RED
scenario on the skill as it stood:

| Finding | RED | Outcome |
|---|---|---|
| A replay of a step that commits could run in the user's product repo | M5 3/3 pass (agents used throwaway clones unprompted, and each said the skill should say so); unprimed M5b 3/3 void (safety classifier) | One conditional line added to step 3.2, labelled **untested**: no faithful unprimed test could run, and a wrong replay commits on the user's PR branch. |
| Replays might load the installed skill, not the worktree copy | M5 3/3 pass (prompts rebuilt from the worktree copy) | Dropped: no failure. |
| `superpowers:writing-skills`' own checklist (commit and push) not overridden | M5 reps 2–3 with writing-skills in view: pass, nothing pushed before step 4 | Dropped: no failure. |
| `cd <worktree>` may not persist between calls | M6 3/3 pass (`cd … &&` on every call); main-thread cwd persists anyway | Dropped. |
| Commit messages not under the general-terms rule | M6 3/3 pass | Dropped: no failure. |
| AskUserQuestion's 4-option cap vs 5–6 findings | M6 3/3 pass (split across questions) | Dropped: no failure. |
| `summarise` missing from the blame list (all three workflow skills call it since the merge) | not tested | Added: a factual list update, not behaviour-shaping wording. |
| `jq` missing from the README requirements | — | Added. |

**Real-session check (plan Review Focus 3).** The reviewer ran on a real past
`/build-from-spec` session with 14 subagent transcripts: it ran `transcript.sh`, opened the 9
subagent transcripts where the work happened, judged the run against the skill version it had
loaded, treated a non-GitHub remote as an environment failure, and returned "No findings."

## Deferred (not fixed)

- If a checkout doesn't ignore `.claude/worktrees/`, the new worktree shows as untracked there.
  This user's checkout excludes it (`.git/info/exclude`).
- A checkout whose remote isn't called `origin`.
- "Stop after step 2" in Before you start is ambiguous (two lists have a step 2).
- No fallback when `find` prints no transcript.
- When every picked finding is dropped, step 4 still asks to commit an empty diff; no cleanup command for the worktree.
- The "some" answer at step 4 needs a follow-up question the skill doesn't spell out.
- `transcript.sh` cuts tool inputs at 500 characters; a subagent's full dispatch prompt is its transcript's first `[user]` line, which the skill could point to.
- R1 fixture predates `build-from-spec`'s new `summarise` step.
- Several workflow runs in one session: combining replies and naming the branch is underspecified.
