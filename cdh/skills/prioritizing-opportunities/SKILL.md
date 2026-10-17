---
name: prioritizing-opportunities
description: Use when choosing which opportunity to pursue next, comparing sibling opportunities on an opportunity solution tree, or when the team asks which customer need to focus on first.
---

# Prioritizing Opportunities

## Overview

You help the trio choose ONE target opportunity from `discovery/<outcome-slug>/ost.md` by walking the tree top-down, comparing siblings level by level. **Agent recommends, human decides** — every branch pick and the final target. File paths and outline format: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`; the anti-patterns cited below (AP7, AP10): `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

## Top-down recipe

1. Read `outcome.md`, `ost.md`, and the snapshots its evidence tags name.
2. Compare ONLY the current level's siblings, starting with the top-level branches. Never score the tree flat: a parent and its child are the same need at different altitudes, so ranking them together double-counts the branch.
3. Build the four-factor table (below), state which sibling you recommend and why, and ask the human to pick.
4. Human picks a branch → descend into it and repeat steps 2–3 with its children.
5. The target is the node the human confirms, with no children worth splitting further.
6. Only after that explicit confirmation: append ` <- TARGET` to the chosen node's line in `ost.md`, and add a dated entry under `## Target history` at the end of the file (append the section if absent): `- YYYY-MM-DD — target: <node>; reasoning: <one line>`. Remove any previous `<- TARGET` marker; the history keeps the record.

No human reply available (one-shot run)? Treat your recommendation as the provisional pick at each level, present each level's comparison and the full recommended path, and end by asking the human to confirm — `ost.md` stays unmarked. A recommendation is recoverable; a wrong marker in the source of truth silently drives ideation.

## The four factors — judgment, not arithmetic

One column per sibling:

| Factor | Question asked of each sibling |
|---|---|
| Opportunity sizing | How many customers hit this, how often? |
| Market factors | Does market context — competitors, timing, openings — favor it? |
| Company factors | Does it fit strategy, brand, and current bets? |
| Customer factors | How much do customers care — how sharp is the pain in the evidence? |

Cells hold short qualitative judgments grounded in snapshots and evidence tags — never numbers. This is explicitly NOT weighted scoring: no scales, no weights, no totals, no formula. The verdict is a reasoned sentence ("X over Y because…"); factors may disagree — say so rather than average the tension away.

## Effort stays out

Effort, cost, and build-size never enter opportunity comparison — they bias the pick toward the easy over the important (AP7). Effort belongs to the solution space: once a target is chosen, `ideating-solutions` and assumption testing weigh what is cheap to try. Asked for a RICE or weighted matrix: build the four-factor sibling table instead and say why — effort is a solution property; this decision chooses a customer need, not a build.

## Framing

Every choice is compare-and-contrast among siblings: "which of these?" — never "should we pursue X?" A yes/no question about one opportunity has no basis; re-frame it against its siblings (AP10).

## Rationalizations

| Excuse | Reality |
|---|---|
| "They asked for a scored matrix, so I'll build one" | The request is input. Explain AP7; deliver the four-factor comparison. |
| "Effort is only a rough estimate, clearly caveated" | A caveated column still steers the pick. It stays out entirely. |
| "The leaf is more actionable than its parent, so it wins" | Different levels never compete. Pick the branch first, then descend. |
| "They said 'just pick it', so marking is what they want" | Recommend and stop. The marker is written only after the human confirms. |
