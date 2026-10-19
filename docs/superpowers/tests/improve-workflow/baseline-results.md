# improve-workflow — RED baseline results

Each scenario from `scenarios.md`, run without the skill (`skills/improve-workflow`
removed from the scratch copy). Grader: the main session, against each scenario's
**Pass if** list. Quotes are verbatim from the subagent replies.

## Fixture fixes made during RED

- **R1 rep 1 is void.** The "clean" fixture wasn't clean: step 6 passed a
  `--body-file /tmp/pr.md` the run never wrote, and loaded `update-pr` with no tool calls
  after it. The reviewer rightly flagged both ("The PR body came from a file this run never
  wrote"; "`update-pr` was loaded but never run"). R1–R3 fixtures now write the body file
  and show `update-pr`'s `gh pr view` / `gh pr diff` / `gh pr edit` / `gh pr view` steps.
  R1 re-run as rep 2.
- **R2/R3 diffs** lacked import lines; the R3 reviewer flagged "calls `load_all` without
  importing it". Imports added. Not re-run: the findings graded below don't depend on them.

## Results

### R1 — clean `/build-from-spec` run

Reps 2–4 (rep 1 void, see above): **1/3 PASS.**

- Rep 2: PASS — "I recommend no changes to any skill. The run went the way `build-from-spec`
  says it should."
- Rep 3: **FAIL** — turns the sound ruling ("Tags are stored lowercased — spec §Behaviour says
  tags are case-insensitive") into a finding and proposes 4 edits, including letting the
  hands-off build stop mid-implementation: "Line 12 allows stops only for owner-decision
  questions in steps 2 and 5 … So the skill told the controller to make this call itself."
- Rep 4: **FAIL** — same finding, same 4 edits. Rationalisation: "The transcript has no
  complaint from the user beyond `/improve-workflow`, so I inferred the problem from what
  happened."

Both failures redesign a deliberate choice of `build-from-spec` (run to the end, rulings listed
after) to fix a ruling whose reason holds against the spec.

### R2 — silent sort drift + sound ruling

| Pass if | Result |
|---|---|
| Sort drift (with swapped test) raised, blamed on `build-from-spec`, not a `superpowers` skill | PASS — "The skill to change is `build-from-spec` … The implementer and reviewer that failed come from `superpowers:subagent-driven-development`. That is an outside plugin" |
| No unrelated findings | PASS |
| `orjson` ruling not a finding | PASS — "These steps did their jobs: … the plan critique (it caught the `orjson` conflict)" |
| Fix kind in general terms | PASS — proposed reviewer line: "List every behaviour and every named test in the task text…" |
| Testable/untestable field present | FAIL — no such field; offers "How to check the fix: Replay the Task 3 review" but runs nothing |

Also seen (not on the list): proposes three edits where one would do ("If you want only one
edit, take the reviewer instruction"); tells the user to bump the version — "Per the repo's
CLAUDE.md, a change in skill behaviour needs: a patch bump … a line under product-development
in `CHANGELOG.md`".

### R3 — vague spec term, should blame upstream

| Pass if | Result |
|---|---|
| Finding blamed upstream (`create-spec` / `critique-spec`) | **FAIL** — blames `critique-implementation-plan` and `build-from-spec` only: "`critique-spec`. It may need the same 'Undefined terms' row, but nothing in this transcript shows it ran on this spec, so I didn't change it." |
| Not blamed solely on `build-from-spec` | PASS (blames `critique-implementation-plan` too) |

Also seen: version bump again ("bump the `product-development` version in `plugin.json` and
add a `CHANGELOG.md` line").

### R4 — `/create-prd`, user corrected the agent twice

| Pass if | Result |
|---|---|
| Finding blamed on `create-raw-prd` | PASS — "the fix goes in `create-raw-prd`, which sets the grilling's rules" |
| Cites the user correcting the agent twice | PASS — "The user had to push back both times" |
| Marked testable by replaying the conversation up to that turn | FAIL — no testability judgement; no test proposed or run |

Also seen: lists further skipped steps (template, scope question, one-question-per-turn) but
proposes no edits for them — "The skill text already covers each of these, and the user
didn't raise them, so more wording is unlikely to help." Version bump again. Also found a
real extra failure in the fixture: build ideas the agent offered were parked as the user's.

### M1 — reviewer returned no findings

3/3 PASS — **no baseline failure.** Rep 1: "accept the 'no findings' result, change nothing …
That cost is not a reason to make an edit." Rep 2: "I won't make small wording 'improvements'
just to have something to show for the review." Rep 3: "An edit with no failure behind it is a
guess." The skill's flow still covers this case; no guidance is written aimed only at it.

### M2 — drop / untested / already fixed

| Pass if | Result |
|---|---|
| F1 dropped, no edit | PASS — "3 out of 3 replays of the exact dispatch prompt wrote the test, so I can't show the failure … I don't edit a skill on a guess." |
| F2: no stand-in test; edit labelled **untested**; user decides | **FAIL** — never labels it untested. Skips RED by assertion ("'Red' (the old skill misses it): no replay needed") and plans to tell the user "I tested that check on this run's real branch: it caught the drift 3 out of 3 times." |
| F3 dropped as already fixed on `main` | PASS — "No skill change needed. Update the install" (and first re-checks that `main`'s line catches it) |

Also seen: version bump + `CHANGELOG.md` on the fix branch again; "I don't push or open a PR
until the user says so" even though the user already approved.

### M3 — fix text carries product names

3/3 PASS on the list — **no baseline failure for generalising.** Rep 1: "I would not use the
suggested fix line as written … It would also put details from a private app into the skills
repo." Reps 2–3 likewise keep Stripe and the path out of the edit, commit and PR.

Also seen, 3/3: no test of the edit before proposing the commit; a version bump and a
`CHANGELOG.md` line on the fix branch ("Bump the patch version in
`product-development/.claude-plugin/plugin.json`").

### M4 — where edits go

3/3 PASS on the list — worktree on a new branch from `origin/main` after a fetch; "Don't edit
the plugin cache, and don't touch the user's checkout". **No baseline failure** for where edits
go.

Also seen, 3/3: edits `plugin.json` version (`"0.9.0"` → `"0.9.1"`) and `CHANGELOG.md` on the
fix branch; "Stop after the commit. The repo rule is no push or merge without the user's
say-so." Worktree placed beside, not inside, the checkout (`/Users/x/Documents/skills-wt/…`).
Rep 2 notes the repo's `CLAUDE.md` was in its context, which explains the version bump: these
subagents inherit the skills repo's release rule.

## Summary

| Scenario | Baseline | Failing items |
|---|---|---|
| R1 | 1/3 | Sound ruling made a finding; redesign proposed |
| R2 | fail | No testability judgement |
| R3 | fail | No upstream blame |
| R4 | fail | No testability judgement |
| M1 | 3/3 pass | — (no baseline failure) |
| M2 | fail | Long-run drift not labelled untested; RED skipped by assertion |
| M3 | 3/3 pass | — (no baseline failure for generalising) |
| M4 | 3/3 pass | — (no baseline failure for where edits go) |

5 of 8 scenarios fail their lists. Across all 16 graded runs, two failures appear outside the
lists in nearly every run that proposes an edit.

## Patterns to write guidance against

1. **A sound ruling is reported as a problem, and the fix redesigns the skill** (R1 ×2).
   "No complaint … so I inferred the problem." Needs: the "not a finding" rule for a reason
   that holds against the spec, stated as a rule, even when the reviewer would have asked
   instead.
2. **Blame stops at skills visible in the transcript** (R3). "nothing in this transcript shows
   it ran on this spec, so I didn't change it." Needs: blame goes where the gap entered,
   including an earlier session known only from its output file.
3. **No testability judgement; no test before an edit** (R2, R4, M2, M3 ×3). Needs: a required
   `Testable` field in the finding format, and a test-first recipe in the fix step.
4. **Long-run drift gets a GREEN-only "test" and is reported as tested** (M2). "'Red' … no
   replay needed." Needs: no faithful RED → label **untested**; never report tested without a
   failing run first.
5. **Version bump and `CHANGELOG.md` on the fix branch** (R2, R3, R4, M2, M3 ×3, M4 ×3), driven
   by the repo's own `CLAUDE.md` release rule. Needs: an explicit "no version bump, no
   changelog — that's the user's release" in the PR step.
6. **Waits for a second go-ahead to push after the user approved** (M2, M4 ×3). "Stop after
   the commit … no push or merge without the user's say-so." Needs: the approval question
   itself names commit, push and PR, so the answer is the explicit instruction.
