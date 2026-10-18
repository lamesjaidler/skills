---
name: create-raw-prd
description: Use when the user wants to write, draft, or create a PRD (product requirements document) for a product idea, feature, or problem, before any spec, design doc, or implementation plan exists.
---

# Create a raw PRD

A **raw PRD** is the first, uncritiqued draft of *what* to build and *why*, written only from the user's own answers. You build it by grilling the user, then filling the template below. It then goes to `critique-prd`.

## Steps

1. **Grill.** Call the Skill tool with `mattpocock-skills:grilling` and run it on the user's idea with this design tree:
   - **Root branches are the template's sections**: problem, users, goals & metrics, non-goals, requirements, assumptions, risks. The tree visits every one.
   - **Product branches only**: who, what, why, how much, what's left out. How it gets built (tech stack, architecture, build vs buy, effort) belongs to the later spec. When the user volunteers a build idea, note it for the hand-off and keep grilling the product.
   - **Already settled, so ask nothing about them**: the PRD's format, audience, and template.

   If the Skill tool can't find `mattpocock-skills:grilling`, tell the user to install the `mattpocock-skills` plugin from `claude-plugins-official`, then stop.

2. **Run the invent check before asking for shared understanding.** Draft each template section in your head and ask: *what would I have to invent to write this?* Every invention is a question still on the frontier; ask it in the next round. Repeat until each section can be written from the user's answers, or holds an item the user chose to defer.

3. **Confirm.** Ask whether you've reached a shared understanding, and name the file you'll write: the repo's existing PRD folder if it has one, else `docs/prd/<slug>.md`.

4. **Write the PRD** to that file using the template. Each line traces to something the user said. Decisions the user deferred go under open questions; beliefs nobody has checked go under assumptions.

5. **Hand off** with exactly this message:

   > PRD written to `<path>`.
   > Open questions: <count>, waiting on <who>.
   > Build ideas parked for the spec: <list, or "none">.
   > Next: critique it with `critique-prd`.

## Template

```markdown
# PRD: <name>

Status: raw draft, not yet critiqued · <YYYY-MM-DD>

## Problem
<who has the problem, what goes wrong, how often, why now, in the user's own numbers>

## Users
<each user type: how many, what they do with the product>

## Goals & success metrics
<each metric: definition, baseline, target; "not set" where the user deferred one>

## Non-goals
<each thing v1 leaves out, with the user's reason>

## Requirements
R1. As a <user>, I want <capability>, so that <benefit>.

## Assumptions & open questions
A1. <belief the PRD rests on that nobody has confirmed>
Q1. <decision the user deferred>, waiting on <who>.

## Risks
<what could make this fail, from the user's answers>
```

Number every R, A and Q item so a critique can cite it.
