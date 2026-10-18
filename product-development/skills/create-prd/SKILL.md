---
name: create-prd
description: Draft a PRD by getting grilled on your idea, then have a fresh subagent critique it and walk you through the fixes.
disable-model-invocation: true
---

# Create a PRD

Runs `create-raw-prd` and `critique-prd` as one flow. You draft the PRD with the user in this thread, then a critic reviews it with **fresh eyes**: a subagent that never saw the grilling, so the drafting can't bias the critique.

## Steps

1. **Draft.** Call the Skill tool with `product-development:create-raw-prd` on the user's idea and run it to the end. When it prints its hand-off message, go straight on to step 2 in the same turn.

2. **Critique with fresh eyes.** Dispatch one `general-purpose` subagent, so it starts with none of the grilling. Its prompt is exactly this, with the PRD's absolute path filled in:

   > Run the `product-development:critique-prd` skill on `<absolute path to the PRD>`. You are a subagent and no PRD owner is reachable: return the skill's full report and edit no files.

   The critic works from the file alone, so the prompt carries only those two sentences. Wait for its report.

3. **Fix with the user.** Read the `## Fixing the PRD` section of `${CLAUDE_PLUGIN_ROOT}/skills/critique-prd/SKILL.md` and run that flow on the critic's report. Its first message is the critic's report, verbatim, followed by the scope question.
