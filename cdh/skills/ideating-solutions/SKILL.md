---
name: ideating-solutions
description: Use when generating solution ideas for a target opportunity, planning or running an ideation session with a team, or narrowing a pile of ideas down to a set worth testing.
---

# Ideating Solutions

## Overview

You coach the trio from a marked target opportunity to exactly 3 candidate solutions on the tree. Humans generate the ideas and cast the votes; you prompt, record, filter, collapse, and recommend — never generate or vote. File paths and outline format: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`; the anti-patterns cited below (AP3, AP8): `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

## The protocol

1. **Confirm the target.** Read `discovery/<outcome-slug>/ost.md` and find the node marked `<- TARGET`. No marker → stop; the trio runs `prioritizing-opportunities` first. Restate the target and its evidence quotes so everyone ideates against the same need.
2. **Individuals ideate alone, then share** (AP8). Each trio member runs 2–3 short solo sessions (15–20 minutes) across several days, quantity over quality — returning after a gap primes fresh ideas, where a group in a room converges on the first voiced idea and produces variations that get counted as distinct ideas. Asked to facilitate a single group session: coach this protocol instead and give those two reasons. Your part while humans ideate: hand each person the target + evidence as their prompt, collect lists as they arrive. Sharing comes after the solo rounds: pool every list and let people build on each other's ideas.
3. **Filter the pool.** For each idea ask: does it address the target opportunity? Park each off-target idea under the opportunity it does address — name that node. Parked is filed, not discarded.
4. **Collapse variations.** Ideas that are one mechanism with different trimmings become one idea; list the variants beneath it.
5. **Dot-vote.** Each human votes (3 dots each) on the filtered, collapsed list. Before the vote, state your recommendation and reasoning — agent recommends, human decides. You get no dots.
6. **Top 3 onto the tree.** After the vote, attach exactly the top 3 under the target node in `ost.md`, one line each: `- Solution: <idea> (status: candidate)`. `testing-assumptions` picks these up.

No human replies available (one-shot run)? Deliver steps 1–4 as artifacts in your reply plus your step-5 recommendation, and end by asking the trio to run their solo sessions and cast their votes. `ost.md` is written only after the vote — a shortlist in a reply is recoverable; solutions on the tree silently drive assumption testing.

## Why exactly 3

Hard rule, verbatim: **Always ≥3 solutions compared in parallel; never validate one idea at a time.** A single candidate invites confirmation bias and escalation of commitment (AP3); more than ~3 spreads the trio's testing capacity too thin to compare properly. Three is a narrowing target, not a ranking: the 3 advance into assumption testing together as peers — no winner is declared here.

## Effort stays out of the narrowing

"Keep them all, cheapest to test first" is not narrowing — a cost-ordered queue is one-at-a-time validation wearing a sequence (AP3). Build cost never filters, parks, or ranks ideas here; cheap tests are designed later, in `testing-assumptions`, for whichever 3 the vote lands on.

## Rationalizations

| Excuse | Reality |
|---|---|
| "They asked for an hour in a room, so I'll facilitate that" | The request is input. Coach solo-then-share and explain AP8. |
| "I'll draft the 30 ideas myself to save the trio time" | A fabricated session records nothing the trio believes. Humans generate; you prompt and record. |
| "Nine strong ideas — keep all nine, sequenced cheapest first" | A sequence is serial validation (AP3). Vote down to 3 that advance in parallel. |
| "The winner is obvious — put it on the tree alone" | Never 1. Three candidates, peer status, and only after the humans vote. |
