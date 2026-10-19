---
name: create-spec
description: Turn a PRD into a finalised spec. You brainstorm the design, then fresh subagents check it's the best approach, prototype any UI for you to pick from, and critique it against the PRD, applying every fix that doesn't need your decision.
disable-model-invocation: true
---

# Create a spec

Runs `superpowers:brainstorming`, `stop-and-think`, `apply-laws-of-ux` and `critique-spec` as one flow, from a PRD to a finalised spec. You draft the spec with the user in this thread. Then subagents check it with **fresh eyes**: they never saw the brainstorming, so they work from the files alone.

The PRD is the file the user named. If they named none, ask for its path. The PRD is read-only: every change this flow makes goes in the spec. When a decision contradicts a PRD line, the spec records the decision and the hand-off lists the line.

## Steps

1. **Draft the raw spec.** Call the Skill tool with `superpowers:brainstorming`. Before its first message, read the PRD and the code the feature builds on. Then run it with the PRD as its starting point:
   - The PRD settles what to build and why. Every question, the first one included, is about how it gets built: which choices (platform, stack, existing code to build on) the user wants to make and which they hand to you, the constraints, and each PRD gap that changes the design (an open `Q`, a requirement two designs would read differently).
   - The result is always a written design document.
   - When the spec is written and brainstorming's builder check is back, go straight on to step 2 in the same turn. The user approves the spec at step 5, and `/build-from-spec` plans it after that.

2. **Check the approach.** Dispatch one `general-purpose` subagent with exactly this prompt, absolute paths filled in:

   > Run the `product-development:stop-and-think` skill on the spec at `<spec>`. The goal comes from the PRD at `<PRD>`. You are a subagent and the user can't be reached: return the skill's full reply and edit no files.

   On **Keep**, go to step 3. On **Adjust** or **Rewrite**:
   - A change that undoes something the user decided while brainstorming is a conflict. Ask about each conflict, then each of the reply's Questions the brainstorming hasn't already answered. One per turn, with AskUserQuestion, recommended option first.
   - Rewrite the spec with every change the user didn't turn down. Tell them in a few lines what changed, and go on to step 3.

3. **Pick the UI.** Only if the spec describes screens or pages a user sees and acts on; otherwise go to step 4. Dispatch one `general-purpose` subagent with exactly this prompt:

   > Run the `product-development:apply-laws-of-ux` skill in Prototype mode on the UI described in the spec at `<spec>` (PRD: `<PRD>`). Build three variants, in new files only: change no existing file. You are a subagent and the user can't be reached: where a skill would ask them something, state your assumption and go on. Return the command to run the prototype, its URL, the hand-off table, and the files you created.

   Show the user the command, URL and table, then ask which variant to take or what to change. A mix or a change goes back to the same subagent by SendMessage, to be built as a new variant the user can open. Repeat until the user picks one variant they have opened, as it is. Then write it into the spec's UI section: each screen, what each user sees and does there, and the law behind each choice. Link the prototype (`<URL>?variant=<key>`) from that section and leave its files in place.

4. **Critique against the PRD.** Dispatch one `general-purpose` subagent with exactly this prompt:

   > Run the `product-development:critique-spec` skill on the spec at `<spec>`. Also check it against the PRD at `<PRD>`: a requirement, goal or metric the spec misses, a non-goal it breaks, and a PRD open question it settles are each a finding. You are a subagent and the user can't be reached: pick the pass mode yourself. Fixes are pre-authorized: apply every proposed edit except those marked **Needs owner**. A finding is **Needs owner** when its edit sets a product rule the PRD and the spec don't settle (who may do what, what users see or are told, money, scope) or answers a PRD open question. Return the skill's full report, with each finding marked **Applied** (with `path:line`) or **Needs owner** (with the question, 2–4 options, and your recommended option first).

   Every **Needs owner** finding is settled by the user: by what they said while brainstorming, or by asking now, one per turn with AskUserQuestion, recommended option first. Apply each answer. A "not now" goes in the spec's open questions.

5. **Hand off** with exactly this message:

   > Spec finalised: `<spec>`.
   > Approach: <Keep, Adjust or Rewrite>, <one line on what changed>.
   > UI: variant <key> from `<prototype URL>`, or "no UI".
   > Critique: <n> fixes applied, <n> decided by you.
   > Open questions: <list, or "none">.
   > PRD lines to update: <each line a decision contradicts, with the decision, or "none">.
   > Next: read and approve the spec, then build it with `/build-from-spec <spec>` from its own branch or worktree, not `main`.
