---
name: ideation-swarm
description: Use when a target opportunity needs a wider pool of solution ideas — the trio's list is thin or circling one mechanism, someone wants product/design/engineering lenses on the same need, or asks for an agent swarm, multi-persona brainstorm, or parallel-agent ideation.
---

# Ideation Swarm

## Overview

Three persona subagents ideate in isolation, are shown the whole pool, then ideate again. You orchestrate and report — you never author ideas yourself and never narrow the result. What comes back is **stimulus material**: agent-authored provocations that widen the trio's own pool. It is not the trio's ideas, not evidence, and not a decision. File paths and outline format: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`; the anti-patterns cited below (AP3, AP8): `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

## The protocol

1. **Brief.** Read `discovery/<outcome-slug>/ost.md` and take the node marked `<- TARGET`, its evidence quotes from the cited snapshots, and the outcome statement from `outcome.md`. No discovery state, or no marker? Use the opportunity as the user states it, in the customer's frame, and say which you used. Every persona gets this same brief verbatim.
2. **Round 1 — three isolated spawns, in parallel.** Dispatch three subagents in a single message: expert product manager, expert designer, expert software engineer. Use the general-purpose subagent type with the persona written into the prompt, so the roster works in any environment. Ask each for 8–10 ideas, one line each, quantity over polish, no ranking, no narrowing. Swap or add a persona when the opportunity needs a lens the three don't cover (support lead, data scientist, ops) — name the roster you used in the reply.
3. **Pool.** Collect all three lists verbatim, tagged with their persona. No dedup, no rewriting, no filtering.
4. **Round 2 — three fresh isolated spawns, in parallel.** Give each persona the full attributed pool plus their own round-1 list, and ask for **new** ideas only: combinations, reactions, ideas the pool made thinkable. Fresh spawns — personas never talk to each other, they only ever see the pool you hand them.
5. **Report** the full list. Nothing generated in either round is dropped before the reply.

## The reply

Exactly these parts, in this order:

1. One line naming the target opportunity, its evidence quotes, and the persona roster.
2. One line: these ideas are agent-authored stimulus, not the trio's ideas.
3. The full list as a table — `| # | Idea | Persona(s) | Round |` — every idea from both rounds, one row each. Identical ideas share a row that lists every persona who reached it; near-variants stay separate rows.
4. A handoff line: the trio takes this pool into their own solo ideation, and `ideating-solutions` runs the filter, collapse, and dot-vote.

Write a file only when asked for one; then it goes to `discovery/<outcome-slug>/ideation/YYYY-MM-DD-swarm.md` with the same four parts. `ost.md` is never touched by this skill.

## Spawn it for real

Three personas in one context is one voice doing three accents. Real parallel subagents, one isolated context each, both rounds — that is the entire mechanism (AP8). Authoring the lists yourself is not a faster version of this skill; it is a different, worse thing wearing its output format.

**No exceptions:**
- Not under deadline pressure, and not when asked to skip the spawning to save time.
- Not "I'll write them myself and label who would have said what."
- Not one subagent asked to produce all three lists.
- Agent/Task tool genuinely unavailable? Say so and stop. Do not simulate.

## Convergence is not a vote

Three personas landing on the same idea is one model's prior surfacing three times, not three experts agreeing. Never report convergence as signal, strength, validation, or a reason to build. Count it once in the `Persona(s)` column and move on.

## No narrowing here

Everything generated is reported. This skill has no top 3, no best idea, no ranking, no pruning, no "start with the cheapest" sequence — a single recommended idea is confirmation bias with extra steps (AP3), and picking winners from an agent-authored pool hands the trio's decision to a model. Narrowing is `ideating-solutions`: humans ideate, humans filter, humans vote.

## Rationalizations

| Excuse | Reality |
|---|---|
| "Deadline is tight — I'll write the three lists myself" | One context, one voice (AP8). Spawning three subagents in parallel is the cheap part. |
| "All three personas said it, so that's the strong one" | One model's prior repeated, not independent agreement. Report it, don't weight it. |
| "Round 1 was rich enough, skip round 2" | Round 2 is where the pool makes new combinations thinkable. Both rounds, always. |
| "Deduping the merged list reads cleaner" | Attribution is the deliverable. Identical ideas share a row naming every persona; nothing loses its origin. |
| "They asked for the single best idea to build" | Return the full pool and say where the narrowing happens. The vote is the trio's (AP3). |
| "These are good enough to put on the tree" | Agent-authored stimulus never reaches `ost.md`. Solutions land there only after the humans' dot-vote in `ideating-solutions`. |
