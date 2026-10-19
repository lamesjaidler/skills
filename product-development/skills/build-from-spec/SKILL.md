---
name: build-from-spec
description: Use when the user runs /build-from-spec with a spec path and wants the spec built end to end, from implementation plan to an open PR, without running each step by hand.
argument-hint: "<path to spec>"
disable-model-invocation: true
---

# Build from spec

Build the spec at `$ARGUMENTS`, open a PR into `main`, and summarise the work for the user. Each review step runs in a fresh subagent, so it judges the work from the files alone. You run the implementation yourself, as its controller.

The user typed `/build-from-spec`, so they want the whole run, including the push and the PR. Do not check in between steps. Stop only for the owner-decision questions in steps 2 and 5, and for the stops that `superpowers:subagent-driven-development` names.

## Before you start

1. If `$ARGUMENTS` is empty, ask for the spec path, then stop.
2. Run `git branch --show-current`. If it prints `main` or `master`, stop. Tell the user to put the spec on its own branch or worktree first.
3. Record `BASE=$(git merge-base main HEAD)`.

Put absolute paths in every dispatch prompt.

## Steps

1. **Plan.** Dispatch a `general-purpose` subagent with this prompt:

   > Run the `superpowers:writing-plans` skill on the spec at `<spec path>`. The execution method is already chosen: subagent-driven. The plan goes straight to an automated critique, so skip the Execution Handoff and ask nothing. Reply with only the plan's absolute path.

2. **Critique the plan.** Dispatch a fresh `general-purpose` subagent with this prompt:

   > Run the `product-development:critique-implementation-plan` skill on the plan at `<plan path>`, and check it against the spec at `<spec path>`. Fixes are pre-authorized: apply every fix that needs no owner decision, and do not apply the others. Reply with: (1) one line per applied fix, with its `path:line`; (2) each owner decision as a question with 2–4 options, your recommended option first and marked "(Recommended)", and the plan edit each option makes.

   Ask its questions one at a time with AskUserQuestion. Apply each chosen edit to the plan. Then commit the plan.

3. **Implement.** Call the Skill tool with `superpowers:subagent-driven-development` and run it on the plan, with two changes:
   - The current branch is the isolated workspace. Do not create a worktree or ask about one.
   - Where it says to use `superpowers:finishing-a-development-branch`, do not. Go to step 4. Keep its "Rulings I made" list for step 6.

4. **Simplify.** Dispatch a fresh `general-purpose` subagent with this prompt:

   > In `<repo path>`, run the `simplify` skill with no argument. The changes to review are `<BASE>..HEAD`. Then run the project's tests. If they pass, commit your changes in one commit. If they fail, revert your changes. Reply with one line per change and the test result.

5. **Security review.** Dispatch a fresh `general-purpose` subagent with this prompt:

   > In `<repo path>`, run the `security-review` skill on this branch. It only reports, so then fix each finding yourself, run the project's tests, and commit the fixes in one commit. If a fix needs an owner decision, do not make it: return it as a question with 2–4 options, your recommended option first and marked "(Recommended)". Reply with each finding, the fix (`path:line`) or the question, and the test result.

   Ask its questions one at a time with AskUserQuestion. Make the chosen fixes, run the tests, and commit.

6. **Open the PR.**
   1. Commit anything `git status --porcelain` still shows.
   2. `git push -u origin HEAD`.
   3. `gh pr create --base main --title '<feature>' --body-file <file>`. The body lists the spec path, the plan path, the "Rulings I made" list, and each security finding with its fix.
   4. Call the Skill tool with `product-development:update-pr` and the PR URL. It rewrites the title and body.
   5. Give the user the PR URL and the "Rulings I made" list.

7. **Summarise the work.** Call the Skill tool with `product-development:summarise` and the plan path. The plan is now carried out, so it summarises the work from the branch's commits. Its reply is the last message of the run.

## Common mistakes

| Mistake | Fix |
|---|---|
| Plan subagent stops to ask for a plan review or an execution method | Its prompt says the method is chosen and to ask nothing. Use the prompt as written. |
| Running `finishing-a-development-branch` after the implementation | Its merge / PR / discard menu replaces steps 4–6. Skip it. |
| Asking "should I continue?" between steps | `/build-from-spec` is the go-ahead for every step. |
| Asking the owner-decision questions in one message | One question per AskUserQuestion call. |
| Leaving the plan or fixes uncommitted | Commit after steps 2, 4 and 5. Step 6 catches anything left. |
