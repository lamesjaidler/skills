# improve-workflow — design

Date: 2026-10-19
Status: draft, awaiting approval
Plugin: `product-development`
Skill: `product-development/skills/improve-workflow/SKILL.md`

## Intent

The user builds products with three skills from this repo, each in its own session:
`/create-prd` → `/create-spec` → `/build-from-spec`. They want the workflow to get a
little better after every run, without waiting for a big failure to notice.

`/improve-workflow` is run by the user at the end of one of those sessions. It looks back
over the run, finds where a skill let the agent go wrong, and fixes that skill so it
doesn't happen again. If nothing went wrong in a way a skill could have prevented, it
says so and changes nothing.

Example from the user: the build doesn't match the spec, and the agent gave no reason
for the difference at the time. `/improve-workflow` traces the gap to the skill that let
it through and tightens that skill.

## Goals

- One command at the end of any of the three sessions, while the run is still on hand.
- Find real skill problems: places the skill led the agent wrong, or failed to stop it.
- Prove each fix works before it's kept (TDD for skills, via `superpowers:writing-skills`).
- Changes reach the skills repo as a reviewable PR, never straight into the installed copy.

## Non-goals

- Reviewing the product itself (the PRD's ideas, the code quality). That's what the
  critique, simplify and security-review steps do.
- Editing skills from other marketplaces (`superpowers`, `mattpocock-skills`).
- Bumping the version, updating `CHANGELOG.md`, merging or releasing. The user does that
  with `scripts/release.sh` as they do today.
- Looking at past sessions by id. It works on the session it's run in.

## Anti-goals (a failure even if it technically works)

- **Change for its own sake.** Editing a skill when nothing needs fixing. "No change
  needed" is a normal, expected result — most runs should end there.
- **Overfitting.** A fix that only makes sense for this one product ("when building the
  billing page…"). Fixes must be general rules a future run of any product would benefit
  from.
- **Skill bloat.** Each fix adds words to a skill that loads on every run. Prefer
  tightening an existing line over adding a section.
- **Leaking product details.** The skills repo is public on GitHub. Commits, PR text and
  any saved test scenarios must not contain names, data, code or decisions from the
  product being built. Describe the failure in general terms.
- **Undoing the user's decisions.** If the user deliberately overrode the skill during the
  run, that's not by itself a bug in the skill. (It may be a sign the skill's default is
  wrong — raise it as a finding for the user to judge, don't assume.)

## When it's used

The user runs `/improve-workflow` as the last thing in a session where `/create-prd`,
`/create-spec` or `/build-from-spec` ran. The session usually lives in a product repo, not
this skills repo.

## Flow

1. **Review the run, with fresh eyes.** The main thread works out which of the three
   skills ran in this session (if none did, say so and stop), then hands the review to a
   fresh subagent — like every other review in this repo. The agent that did the work
   would otherwise judge its own departures, and by the end of a long run its context is
   full or summarised.

   The reviewer reads the session transcript from disk, not the main thread's memory:
   `~/.claude/projects/<cwd-slug>/<session-id>.jsonl`, plus the subagent transcripts in
   `<session-id>/subagents/*.jsonl` (in `/build-from-spec` nearly all the work happens in
   subagents). It also reads the files the run used and made:
   - `/create-prd`: the PRD.
   - `/create-spec`: the PRD and the spec.
   - `/build-from-spec`: the spec, the plan, and the branch diff / PR.

   It returns a list of possible problems. Each one names: what happened (pointing at the
   moment in the transcript), what the skill says at that point, which skill to blame, and
   the kind of fix.

2. **Show the user the list.** They pick which to pursue, or none. If the list is empty,
   reply "no change needed" with one or two lines of why, and stop.

3. **Test and fix each picked problem** with `superpowers:writing-skills`:
   - Turn the moment from the run into a faithful scenario: the skill text, plus the
     situation the agent was in at that point. For a subagent step, that's its exact
     dispatch prompt from the transcript. For one turn of a conversation with the user
     (e.g. a grilling question), that's the conversation up to that turn.
   - Run it in a fresh subagent with the **current** skill. If the agent now does the
     right thing, the problem was a one-off: drop it and tell the user.
   - Otherwise edit the skill, run the same scenario again, and keep the edit only if the
     agent now behaves.
   - **When no faithful scenario can be built** — the problem only builds up over many
     turns with the user or over a long run — don't run a test that would pass for the
     wrong reason. Write the proposed edit, mark it
     **untested** with the reason, and let the user decide whether to keep it. The label
     carries into the PR.

4. **Show the user** the diff and the before/after test results.

5. **On approval**, commit to a new branch in the skills repo and open a PR into `main`.
   Stop there.

## What counts as a problem

A finding is any of these, where **no good reason was given at the time**:

- The agent skipped, reordered or changed a step the skill set out.
- The agent followed the skill, but the skill's wording led to a bad result (a vague
  instruction read two ways, a missing step, a subagent prompt that left something out).
- An output doesn't match its input: the build differs from the spec, the spec drops or
  contradicts a PRD line, the plan misses part of the spec.
- The user had to step in to correct the agent, or repeat themselves.

Not a finding:

- A departure the agent gave a sound reason for at the time — including a
  `/build-from-spec` "Rulings I made" entry whose reason holds up against the spec. The
  user doesn't have to have accepted it; the test is whether a reason was given and
  whether it holds. A ruling with no reason, or one that doesn't hold, is a finding.
- The user changing their mind.
- One-off environment failures (network, a tool crashing, auth).

## Which skill gets the blame

- Any of the three workflow skills, or the helper skills in `product-development` they
  call (`create-raw-prd`, `critique-prd`, `stop-and-think`, `apply-laws-of-ux`,
  `critique-spec`, `critique-implementation-plan`, `update-pr`).
- **Upstream blame is allowed.** A problem seen in a `/build-from-spec` run may come from a
  vague spec, so the fix may belong in `/create-spec` (or `critique-spec`). Likewise a
  `/create-spec` run can blame `/create-prd`. The upstream session isn't available — only
  its output file — so it works from that file.
- When the root cause is in a third-party skill, the fix goes in the user's skill that
  calls it (usually the dispatch prompt or the step that wraps it).

## Constraints

- **Where edits go.** The session runs in a product repo, so the skill must find the
  skills repo checkout. `~/.claude/plugins/known_marketplaces.json` lists the `skills`
  marketplace; when its source is `"directory"`, that path is the checkout. Never edit the
  plugin cache copy. If there's no local checkout (installed from GitHub), ask the user
  for one, else stop.
- **Who it's for.** Anyone with a local checkout they can push to. The PR goes to that
  checkout's `origin`, so someone working from a fork gets the PR on their fork, not this
  repo. The README row says it needs a local checkout.
- **Don't disturb the user's checkout.** Work in a new git worktree on a new branch cut
  from `main`, so uncommitted work in the main checkout is untouched.
- **Repo rules apply** (`CLAUDE.md` in the skills repo): skill directory name equals its
  `name:`; run `bash scripts/validate-marketplace.sh` before committing; match each
  skill's existing voice and structure.
- **Manual only.** `disable-model-invocation: true`, like `create-spec` and
  `build-from-spec`. It should never fire on its own.
- `superpowers` is already a declared dependency of `product-development`; nothing new to
  install.

## Decided by the user

- Run at the end of each of the three sessions, one session per skill.
- No changes when the skills don't genuinely need updating.
- Helper skills can be blamed and edited if they're in this repo; third-party skills
  can't, so the calling skill is adjusted instead.
- Edits go to the skills repo on a new branch, not the installed copy.
- The user sees the list of problems first and picks which to pursue.
- Fixes use `superpowers:writing-skills` (test fresh first, drop if it doesn't fail, then
  fix and re-test).
- A problem with no faithful test (builds up over many turns or a long run) gets a
  proposed edit marked **untested**; the user decides whether to keep it. A single turn
  with the user can be replayed, so it is tested.
- The user sees the diff and test results before anything is committed.
- It commits, opens a PR, and stops. The user merges, bumps and releases.

## My calls (Claude's, for the user to check)

- Lives in `product-development`, as `improve-workflow`.
- Upstream blame (build → spec, spec → PRD) is in scope.
- "The user had to correct the agent" counts as a finding.
- A user's deliberate override is raised as a finding for them to judge, not assumed to be
  a skill bug.
- The review runs in a fresh subagent that reads the transcripts from disk, including
  subagent transcripts.
- A departure with a sound reason given at the time isn't a finding, even if the user
  never explicitly accepted it (follows the user's "no logical/rational reason" framing).
- Works for any local checkout; PRs go to that checkout's `origin`.
- One branch and one PR per run; one commit per fix.
- Test scenarios aren't committed to the repo (they come from a private product). The PR
  body carries a short, generalised before/after summary instead.
- The hand-off messages of the three workflow skills are not changed to remind the user
  to run `/improve-workflow`.

## Left to the builder

- Exact wording of the skill and its step prompts.
- How the main thread finds its own session id / transcript path (e.g.
  `${CLAUDE_SESSION_ID}` if skills can use it, else the newest transcript for the cwd).
- Number of reps per test scenario (follow `writing-skills`).
- How the problem list is presented and picked (AskUserQuestion multi-select fits).

## Docs to update with the skill

- `README.md` — new row in the skills table, and the plugin summary paragraph.
- `CLAUDE.md` — the `product-development` description and the cross-marketplace
  dependency note (`improve-workflow` calls `superpowers:writing-skills`).
- `product-development/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` —
  description and keywords.
- `CHANGELOG.md` is added at release time, not in this branch.

## How we'll know the skill works

Pressure scenarios (per `writing-skills`) built from fake session records, each checked
with and without the skill:

1. A clean run → "no change needed", no edits.
2. An unexplained step skipped in `/build-from-spec` → finding blamed on
   `build-from-spec`, fixed, re-tested.
3. A departure the agent gave a sound reason for → no finding. The same departure with no
   reason → finding.
4. A build that drifts because the spec was vague → blame goes upstream to `create-spec`.
5. A finding that doesn't reproduce in a faithful fresh-subagent test → dropped, no edit.
6. A finding that builds up over a long run → proposed edit marked untested, not
   dropped. A finding in one grilling turn → tested by replaying the conversation up to
   that turn.
7. A fix that would name the product's details → generalised before it's written.
