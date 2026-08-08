---
name: mapping-opportunities
description: Use when someone has a product or business outcome and needs to find the customer needs, pain points, and desires behind it — building or updating an opportunity solution tree, opportunity map, or opportunity space. Triggers include "what opportunities drive this outcome", "build an opportunity solution tree", "map the opportunity space", "synthesise my interviews into opportunities", "what are the pain points for X".
---

# Mapping Opportunities

## Overview

Turn an outcome into a structured opportunity space — the customer needs, pain points, and desires standing between the team and that outcome. Core principle, from Teresa Torres: **opportunities are collected from customers, not invented.** Anything reasoned rather than heard is a hypothesis, and every node says which it is, so a guess is never mistaken for a finding.

**REQUIRED BACKGROUND:** Read `${CLAUDE_PLUGIN_ROOT}/opportunity-principles.md` before mapping. It holds the outcome triage, the seven framing rules, the anti-slop discipline, the evidence tags, and the map file format used throughout. Do not map from memory alone.

## When to use

- "What opportunities drive this outcome?" / "Build an opportunity solution tree."
- Synthesising interview notes, support tickets, or churn surveys into an opportunity space.
- Updating an existing opportunity map after new research.

**Not for:** ideation, solution design, assumption tests, or prioritisation frameworks. The tree stops at opportunities.

**Related:** to gather the evidence this skill needs — `qualitative-product-research:practicing-user-interviews` to rehearse, `qualitative-product-research:live-interview-copilot` to run one live.

## Workflow

### 1. Triage the outcome

Classify what you were handed against the table in `opportunity-principles.md` — business outcome, product outcome, traction metric, or customer desire. Name the specific defect, then propose **exactly one** reframed product outcome. Offer three choices: take the proposal, keep the original, or edit it.

One round trip maximum. Never block — map against whichever they pick.

### 2. Take stock of evidence

Check for an existing `docs/discovery/<outcome-slug>-opportunity-map.md` first. If one exists you **update** it, never overwrite.

Then ask what evidence exists — interview transcripts or notes, support tickets, sales-call notes, session recordings, churn surveys, analytics. Their answer picks the mode below.

### 3. Map, in the mode the evidence allows

**Evidence mode.** Synthesise each interview **separately first** — one snapshot per interview: who they are, their context, their experience, and the opportunities heard *verbatim*. Skipping this loses the nuance and context that make the research actionable. Only then amalgamate the individual experiences into one experience map, group opportunities under the moment where each occurred, and structure **one branch at a time** into parent/child/sibling relationships.

**Hypothesis mode.** Build a *hypothesised* experience map for the segment, then candidate opportunities under each moment, every node tagged `⚠ ASSUMPTION`. State plainly that these are not opportunities — they are guesses to falsify — and that the deliverable that matters is the interview plan in step 5.

**Mixed mode.** Both, tagged per node. This is the common real case.

### 4. Gate on quality before writing

Run every node through the seven framing rules and rewrite the violations. Cap at ~4 candidate opportunities per moment. Every `⚠ ASSUMPTION` node carries a falsifier — the specific past-behaviour question that would kill it. No falsifier, no node.

### 5. Write the map

Write `docs/discovery/<outcome-slug>-opportunity-map.md`, relative to the root of the project you are working in — not the plugin's repo. If no consuming project root is evident, say so, show the map inline instead, and ask where the file should go. Sections in order: outcome (noting its triage type and any reframe), experience map, interviews (one snapshot per interview, per step 3), opportunity space with a per-node evidence tag, parked solutions, open questions → an interview plan targeting the weakest-evidence nodes. Full format, the seven framing rules, and evidence-tag definitions all live in `opportunity-principles.md` — this workflow applies them, it does not restate them.

## Common mistakes

- Emitting a dozen plausible generic bullets that read like findings. Volume is not insight.
- Relabelling an interviewee's words into PM-speak instead of mirroring them.
- Building the tree in evidence mode without synthesising each interview separately first.
- Letting a feature pitched mid-session into the opportunity space — it goes to parked solutions.
- Untagged nodes, or an assumption node with no falsifier.

## Rationalisations — and why they fail

**Violating the letter of these rules is violating the spirit of them.**

| Excuse | Reality |
|---|---|
| "not as pushback, just so you're not surprised in the room" / "it can happen the same week without touching the roadmap timeline" | Both land after the ranking is already on the slide — an aside and a bolt-on extra, not a replacement. The cheap validation has to replace the ranking, not footnote it. |
| "make sure the slide's language says 'top 3 hypotheses' rather than 'validated priorities'" | A room acts on the order, not the header above it. Renaming an ordinal list "hypotheses" doesn't remove the ordering — it just makes the ranking harder to challenge. |
| "a reasonable way to produce a roadmap slide under a hard deadline with zero budget" / "product judgment applied to stated pain and proximity to the metric, not evidence" / "one coherent bet if the VP asks 'why these three together'" | A deadline, the word "judgment," and a story that lands well with the VP are all reasons a ranking is convenient — none of them are evidence #1 beats #2. Under real time pressure the honest deliverable is still a cheapest-test-first sequence — ordered by cost and speed to test, not by assumed impact, and never presented as a build or roadmap order; it fits on the same slide. |
| "treat it as a strong starting draft to pressure-test against 8-10 real conversations … not a substitute for them" / "a hypothesis map, not validated research" | The disclaimer sits in the prose at the top and bottom; nothing in the body of the tree tells a guess from a finding. Tag every node `⚠ ASSUMPTION` with a falsifier instead of hedging around the outside of it. |
| "with a sample of two, that overlap is the closest thing to a confidence signal available" / "enough to draft a strong first-cut opportunity space … not enough to size or rank it with confidence" / "Cluster 3 is directional, not confirmed" | n=2 is n=2. Write the tag — `✓ P3, P7 (2 interviews)` — and let the reader see exactly who said it, instead of a mood word like "confidence signal" or "directional" standing in for the count. |
| "Keep all six in the map; weight prioritization toward the first three." | "Weight toward" orders the six exactly as a ranked list would. Three areas were favoured over the other three on no more evidence than the ranking this skill forbids elsewhere. |

## Red flags — stop

- You are about to rank, score, or roadmap `⚠ ASSUMPTION` nodes, or `✓` nodes on thin evidence (a single interview, a handful of tickets) — by any method, numeric or ordinal, ranked or an unranked "top 3 for the slide." Every notation borrows confidence the tree doesn't have; a caveat sitting beside a delivered ranking doesn't fix it, and neither does relabelling the list "hypotheses" instead of "priorities." Give the interview plan or a cheapest-test-first sequence instead — ordered by cost and speed to test, never by assumed impact, and never presented as a build or roadmap order.
- You are about to name an opportunity no customer said.
- A node reads "increase X" — that is an outcome, not an opportunity.
- Any node in the tree carries no evidence tag.
- You are about to justify a ranking by the deadline, the missing budget, or how it will land with a stakeholder — pressure is not evidence, however reasonable it sounds.
- You are about to write a hedge — "not validated research," "a strong first-cut," "directional, not confirmed," "a confidence signal" — into a sentence instead of onto a node's evidence tag.
- You are about to tell someone to "weight" or "lean toward" some opportunities over others without a ranked list — that is a ranking in different words.
