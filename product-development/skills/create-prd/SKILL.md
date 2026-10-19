---
name: create-prd
description: Draft a PRD by getting grilled on your idea, then have a fresh subagent critique it and walk you through the fixes. Offers a new worktree and branch first, and ends with a summary of the PRD.
disable-model-invocation: true
---

# Create a PRD

Runs `create-raw-prd`, `critique-prd` and `summarise` as one flow. You draft the PRD with the user in this thread, then a critic reviews it with **fresh eyes**: a subagent that never saw the grilling, so the drafting can't bias the critique.

## Steps

1. **Workspace.** Pick `<slug>`: 2–4 kebab-case words from the user's idea. Your first message is one AskUserQuestion: create a new worktree and branch `prd/<slug>` for this project, or work in the current checkout? It carries no other question. Wait for the answer.
   - **New worktree:** call `EnterWorktree` with `name` set to `prd-<slug>`, then rename the branch it reports with `git branch -m <that branch> prd/<slug>`. The PRD is written inside the worktree.
   - **Current checkout:** change nothing.

   Then go on to step 2.

2. **Draft.** Call the Skill tool with `product-development:create-raw-prd` on the user's idea and run it to the end. When it prints its hand-off message, go straight on to step 3 in the same turn.

3. **Critique with fresh eyes.** Dispatch one `general-purpose` subagent, so it starts with none of the grilling. Its prompt is exactly this, with the PRD's absolute path filled in:

   > Run the `product-development:critique-prd` skill on `<absolute path to the PRD>`. You are a subagent and no PRD owner is reachable: return the skill's full report and edit no files.

   The critic works from the file alone, so the prompt carries only those two sentences. Wait for its report.

4. **Fix with the user.** Read the `## Fixing the PRD` section of `${CLAUDE_PLUGIN_ROOT}/skills/critique-prd/SKILL.md` and run that flow on the critic's report. Its first message is the critic's report, verbatim, followed by the scope question. The flow ends when its apply report is sent, or when the owner chooses no fixes. Then go straight on to step 5 in the same turn.

5. **Summarise.** Call the Skill tool with `product-development:summarise` on the PRD's absolute path, and send its summary as the last message of this flow. The critique has already run, so the summary's last line is this, in place of the `critique-prd` line:

   > Next: make a spec from the PRD with `/create-spec <absolute path to the PRD>`.
