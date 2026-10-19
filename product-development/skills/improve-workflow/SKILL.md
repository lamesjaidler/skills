---
name: improve-workflow
description: Use when the user runs /improve-workflow at the end of a /create-prd, /create-spec or /build-from-spec session and wants the workflow skills improved from what happened in that run.
disable-model-invocation: true
---

# Improve the workflow

Review the run in this session and fix the skill that let it go wrong, so the next run doesn't. A fresh subagent reviews the run, each fix is tested with `superpowers:writing-skills` where a faithful test exists, and the fixes reach the skills repo as a PR. "No change needed" is the usual result: when the run shows nothing to fix, say so and change nothing.

## Before you start

1. Find which of `/create-prd`, `/create-spec` and `/build-from-spec` ran in this session (also as `product-development:` names). If none did, tell the user there is no run to review, and stop. If several did, review each.
2. Find the transcript: `find ~/.claude/projects -maxdepth 2 -name '${CLAUDE_SESSION_ID}.jsonl'`.
3. Note the run's files from the conversation: the PRD, the spec, the plan, and for `/build-from-spec` the repo path and its `BASE`.
4. Find the skills checkout: `jq -r '.skills.source | select(.source == "directory") | .path' ~/.claude/plugins/known_marketplaces.json`. If it prints nothing, ask the user for the path of a local checkout of this marketplace they can push to. Without one, stop after step 2. Never edit `${CLAUDE_PLUGIN_ROOT}`: it is the installed copy.

Put absolute paths in every dispatch prompt.

## Steps

1. **Review.** Dispatch one fresh `general-purpose` subagent per run with this prompt:

   > Read `${CLAUDE_PLUGIN_ROOT}/skills/improve-workflow/reviewing-a-run.md` and follow it. Review the `/<skill>` run in the transcript at `<transcript>`. Run files: <PRD, spec, plan; for a build, `git -C <repo> diff <BASE>..HEAD`>. The skills as they ran are in `${CLAUDE_PLUGIN_ROOT}/skills/`. Edit no files. Reply with the guide's output and nothing else.

2. **Pick.** If the reply is `No findings.`, tell the user "No change needed:" and its reason, and stop. Otherwise show the findings verbatim, then ask which to pursue with one AskUserQuestion (multiSelect). If the user picks none, stop.

3. **Test and fix.** Make a worktree from the checkout's `main`, so the user's checkout stays untouched:

   ```bash
   git -C <checkout> fetch origin main
   git -C <checkout> worktree add -b improve/<skill>-<YYYYMMDD-HHMM> <checkout>/.claude/worktrees/improve-<skill>-<YYYYMMDD-HHMM> origin/main
   ```

   In the worktree, a skill lives at `product-development/skills/<skill>/`. For each picked finding:
   1. Diff the blamed skill in `${CLAUDE_PLUGIN_ROOT}/skills/<skill>/` against the worktree's copy. If `main` already fixes it, drop the finding.
   2. **Testable: yes.** **REQUIRED SUB-SKILL:** use `superpowers:writing-skills`. RED: build the scenario the finding's `Testable` line names (a subagent's exact dispatch prompt, or the conversation up to that turn) and run it 3 times on the worktree's copy of the skill, not the installed one, each in a fresh subagent. When the replayed step changes files (it edits, commits or reverts), give each run its own throwaway clone of the product repo, at the commit that step started from, with its remote removed; never replay it in the user's repo. If none fails, drop the finding: it was a one-off. GREEN: make the smallest edit, run the same scenario 3 more times, and keep the edit only if all 3 pass.
   3. **Testable: no.** Write the smallest edit and label it **untested**, with the reason. A fix counts as tested only after a RED run that failed.

   Write every edit in the skill's own voice and in general terms: the repo is public, so no product names, data, paths or code. Keep scenarios in the scratchpad, never in the repo.

4. **Show.** Show `git -C <worktree> diff`, then one line per finding: tested (RED <n>/3 failed, GREEN 3/3 passed), **untested** (why), or dropped (why). Ask with AskUserQuestion: "Commit these fixes, push the branch and open a PR?", with options all, some, or none. On none, tell the user nothing was committed and give the worktree path; stop.

5. **Open the PR.** `cd <worktree>` first: the script and `gh` work from the current folder.
   1. Commit each approved fix on its own, with only its skill files. Leave `plugin.json` and `CHANGELOG.md` as they are: the version bump and changelog line belong to the user's release.
   2. Run `bash scripts/validate-marketplace.sh`.
   3. `git push -u origin HEAD`, then `gh pr create --base main --title '<skill>: <what changes>' --body-file <file>`, with a body file you write now in the scratchpad. The body lists each fix in general terms with its test result or **untested** label, and each dropped finding with why.
   4. Give the user the PR URL and the next step: merge it, then `scripts/release.sh product-development <next version>` and a `CHANGELOG.md` line. Stop.

## Common mistakes

| Mistake | Fix |
|---|---|
| Making a sound ruling a finding, then redesigning the skill around it | A reason that holds against the spec is not a finding, even if you would have asked instead. |
| Blaming only skills that appear in this transcript | A gap in the spec or PRD is blamed on the skill that wrote it; the file is the evidence. |
| Editing a `Testable: yes` finding before its test has failed | RED first. No failure, no edit. |
| Reporting a long-run drift as tested ("no replay needed for RED") | No faithful RED means **untested**. Label it. |
| Bumping `plugin.json` or adding a `CHANGELOG.md` line | That's the user's release. Commit only the skill files. |
| Asking again before pushing | The step 4 approval names commit, push and PR. Go ahead. |
| Editing `${CLAUDE_PLUGIN_ROOT}` or the user's checkout | Edit only in the new worktree. |
