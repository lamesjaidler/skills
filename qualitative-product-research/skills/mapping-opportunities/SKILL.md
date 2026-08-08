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

Write `docs/discovery/<outcome-slug>-opportunity-map.md`, relative to the root of the project you are working in — not the plugin's repo. Sections in order: outcome (noting any reframe), experience map, interviews (one snapshot per interview, per step 3), opportunity space with a per-node evidence tag, parked solutions, open questions → an interview plan targeting the weakest-evidence nodes. Format in `opportunity-principles.md`.

The full seven framing rules and evidence-tag definitions live in `opportunity-principles.md` — this workflow applies them, it does not restate them.

## Common mistakes

- Emitting a dozen plausible generic bullets that read like findings. Volume is not insight.
- Relabelling an interviewee's words into PM-speak instead of mirroring them.
- Building the tree in evidence mode without synthesising each interview separately first.
- Letting a feature pitched mid-session into the opportunity space — it goes to parked solutions.
- Untagged nodes, or an assumption node with no falsifier.

## Red flags — stop

- You are about to rank, score, or roadmap `⚠ ASSUMPTION` nodes. Ranking guesses by impact × reach is fake precision — the output looks like a plan and carries none of the confidence the numbers imply. Give the interview plan instead.
- You are about to name an opportunity no customer said.
- A node reads "increase X" — that is an outcome, not an opportunity.
- Any node in the tree carries no evidence tag.
