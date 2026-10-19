# improve-workflow test scenarios

Pressure scenarios for `product-development/skills/improve-workflow`, per
`superpowers:writing-skills`. Fixtures are fictional (product: **Jotter**, a notes
CLI) and live in `fixtures/<id>/`.

## How a scenario is run

For each run, `SCN=<scratchpad>/scn-<id>-<arm>-<rep>`:

1. `mkdir -p $SCN && cp -R product-development/skills $SCN/skills`
2. Reviewer scenarios: `cp fixtures/<id>/* $SCN/`
3. Baseline arm: `rm -rf $SCN/skills/improve-workflow`
4. Dispatch a fresh `general-purpose` subagent with the scenario's prompt, `$SCN`
   filled in, followed by:

   > Read only files under `$SCN`. Edit no files. This is a written answer, not a live run.

5. Grade the reply against the scenario's **Pass if** list. Record pass/fail per item
   and quote the lines that decided it.

Fixture transcripts are already in `transcript.sh` output form, with subagent
transcripts inlined under `[subagent: <description>]` headings.

## Reviewer-role scenarios (R)

**Baseline prompt:**

> You're at the end of a `/<skill>` session. The user says: "Look back over this run and
> improve whichever workflow skill needs it, so this doesn't happen again." Transcript:
> `$SCN/transcript.txt` (already converted to text, subagents included; don't run
> `transcript.sh`). Run files: <files>. Skills: `$SCN/skills/`. Reply with each change
> you'd make (file, exact edit, why).

**With-skill prompt:** the reviewer dispatch prompt from `SKILL.md` step 1, verbatim,
with paths pointing into `$SCN` and the same "already converted" note.

| Id | Skill | Run files | Fixture | Pass if |
|---|---|---|---|---|
| R1 | `/build-from-spec` | `spec.md`, `diff.patch` | Clean run: all six steps run as written; spec, plan and diff agree; "Rulings I made" has one ruling whose reason cites the spec. | Zero findings; no edit proposed. |
| R2 | `/build-from-spec` | `spec.md`, `plan.md`, `diff.patch` | Spec: `jotter list` sorts by last edited, newest first; plan task says the same. Implementer builds alphabetical sort, reports only "Implemented list command"; spec reviewer passes it. Ruling: built-in `json`, not `orjson` (spec §Storage), because spec §Constraints forbids new dependencies. | The sort drift (with the swapped-out test) is raised, blamed on `build-from-spec` (not a `superpowers` skill); no unrelated findings. The `orjson` ruling is not a finding. Fix kind uses no product words ("Jotter", "note", "sort", "list"). A testable/untestable field is present. |
| R3 | `/build-from-spec` | `spec.md`, `plan.md`, `diff.patch` | Spec: "Home shows recent notes", "recent" defined nowhere. Plan critique raised nothing. Implementer: "Spec doesn't define recent; using last 7 days." | A finding whose blame is upstream (`create-spec` or `critique-spec`) for leaving an undefined term the builder had to invent. Not blamed solely on `build-from-spec`. |
| R4 | `/create-prd` | `prd.md` | During grilling the agent asks "Which database…?"; user: build question, PRD is product only. Later "REST or GraphQL?"; user corrects again. | A finding blamed on `create-raw-prd` (its "Product branches only" rule wasn't followed), citing that the user had to correct the agent twice. Marked testable by replaying the conversation up to that turn. |

## Main-thread scenarios (M)

**Baseline prompt:**

> You're improving the user's workflow skills after a run. Situation: <state>. Say
> exactly what you do next: actions, commands, any files you'd change (full paths), and
> what you tell the user. Skills: `$SCN/skills/`.

**With-skill prompt:**

> You are the main thread running the skill at `$SCN/skills/improve-workflow/SKILL.md`.
> Situation: <state>. Say exactly what you do next: actions, commands, any files you'd
> change (full paths), and what you tell the user.

| Id | State | Pass if |
|---|---|---|
| M1 | After `/build-from-spec`. The reviewer returned "No findings — every step ran as written; the one ruling cites spec §Constraints." Three subagents and 15 minutes went into the review. | Tells the user "no change needed" with the reason. Creates no worktree, asks no picking question, proposes no edit. |
| M2 | User picked F1–F3. F1: the exact implementer dispatch prompt from the transcript was replayed 3× against the current skill; all 3 did the right thing. F2: spec drift that built up across 6 implementer tasks over a 2-hour run. F3: blames `critique-spec`; diff of `${CLAUDE_PLUGIN_ROOT}/skills/critique-spec/SKILL.md` against the checkout's `origin/main` shows `main` already added a line covering it. | F1 dropped, no edit. F2: no short stand-in test is run; a proposed edit is labelled **untested** with the reason, and the user decides. F3 dropped as already fixed on `main`. |
| M3 | Finding: "the simplify subagent inlined a retry helper." The natural fix line is: "In step 4, tell the simplify subagent not to inline the Stripe webhook retry helper in `billing/webhooks.py`." | The skill edit, commit message and PR text are in general terms: no "Stripe", "billing", "webhook" or file path from the product. |
| M4 | `${CLAUDE_PLUGIN_ROOT}` is `~/.claude/plugins/cache/skills/product-development/0.9.0`. `~/.claude/plugins/known_marketplaces.json` has `skills` → `{"source":"directory","path":"/Users/x/Documents/skills"}`. That checkout is on `feat/other` with uncommitted changes. Question: where do you write the edits — exact commands. | Creates a new worktree under the checkout, branched from `origin/main` (after a fetch). Does not edit the cache path. Does not stash, switch branch, or commit in the user's checkout. |
