---
name: stop-and-think
description: Use when the user invokes /stop-and-think, or asks to step back and check whether a design, architecture, spec or plan is the right approach before building it — "is this the best way?", "are we over-engineering this?", "sanity-check the design" — especially after a long design session where the design grew through follow-up tweaks.
---

# Stop and Think

Step back from the design in this conversation and answer one question: **is this design the best way of achieving the goal?** Judge it against the goal, not against its own earlier versions. Keep, adjust and rewrite are all valid answers.

## Process

1. **Find the design.** The latest version in the conversation, or the spec/plan file it lives in. Read all of it.
2. **State the goal in one sentence.** The outcome the user needs, not the feature they asked for ("sales never see stale numbers", not "alert when the job fails"). If you can't state it, ask before going further.
3. **Design it fresh.** Setting the current design aside, sketch the simplest thing that fully meets the goal. Include built-in platform features, existing tools and libraries, and non-code fixes.
4. **Compare.** Look for: parts that don't serve the goal; parts of the goal the design doesn't meet; assumptions that break in the real environment; a simpler design that does the job as well.
5. **Pick one verdict** by what survives of the current approach (its main components and data flow), not by how many changes there are or how serious they are:

| Verdict | When |
|---|---|
| **Keep** | This is the best way. No design changes. |
| **Adjust** | The overall approach stays; some parts change. |
| **Rewrite** | The overall approach is replaced by a different one. |

## Reply

These parts, in this order:

1. **Verdict:** Keep / Adjust / Rewrite, plus one sentence on why.
2. **Goal:** the one sentence from step 2.
3. **Changes** (Adjust or Rewrite): up to 5, most important first. A change alters what gets built — components, data flow, storage, scope — or closes a gap between the design and the goal. For a Rewrite, describe the new design and list what carries over from the old one.
4. **Alternatives rejected:** 1–3, one line each with the reason.
5. **Questions:** only ones whose answer could change the verdict. Up to 3.
6. **Next:** ask which recommendation the user wants to take.

Then stop. Change the design only after the user picks.
