---
name: mapping-the-opportunity-space
description: Use when turning interview snapshots into opportunities, building or updating an opportunity solution tree, structuring or restructuring the opportunity space, or mapping the current customer experience.
---

# Mapping the Opportunity Space

## Overview

You maintain `discovery/<outcome-slug>/ost.md` — the living opportunity solution tree — and `experience-map.md` beside it. Requested additions that pass the validity tests go straight in; moving, merging, splitting, promoting, or removing existing nodes you recommend in your reply, and the human decides.

File paths, outcome-dir selection, and the exact `ost.md` outline format: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`. Follow that outline exactly — the file is `ost.md`, its root the outcome statement copied from `outcome.md`; Mermaid or ASCII diagrams are on-demand views, never stored. These malformations are AP6 in `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

## Opportunity validity tests

Run this checklist on EVERY node added or edited — including ones the human hands you:

1. **Customer-framed**: a need, pain point, or desire in the customer's words — not a company goal ("increase signups" is an outcome, not an opportunity).
2. **A need, not a solution**: "build a Chrome extension" is a solution — parkable as `- Solution: <idea> (status: candidate)` under the opportunity it addresses; if no evidence says which, ask the human, don't guess a parent.
3. **Not a bare feeling**: "expenses are frustrating" is unaddressable; find the need beneath it.
4. **Addressable by this team**, and drives THIS outcome — off-outcome needs go in your reply as candidates for another tree.
5. **Multi-solution**: more than one possible solution could address it.
6. **Exactly one parent**, and distinct from its siblings.
7. **Traces to evidence**: carries `[evidence: <snapshot file>]`; no source → ask, or leave it out.

A node that fails stays out — name the failed test and recommend an alternative. The requester's wording never overrides the tests: the node label is the customer's words even when the request paraphrases.

## Harvest recipe

1. Read `outcome.md` and every snapshot in `discovery/snapshots/`.
2. For each "Opportunities heard" line: match to an existing node (append the snapshot to its evidence tag), add a new leaf where it fits, or mark it not relevant to this outcome in your reply.
3. Run the validity tests on each placement; write the tree in the layout file's outline format.
4. **Done when** every snapshot in the pool is either harvested into the tree or explicitly marked not-relevant to this outcome.

`ost.md` holds the outline only — commentary, flags, and recommendations go in your reply, never extra sections in the file. Ideating and ranking belong to `ideating-solutions` and `prioritizing-opportunities`; solutions enter only from the human or that skill.

## One interview is a data point, not a mandate

New evidence lands where it fits: an evidence tag on an existing node, or a new leaf — tagged, flagged n=1 in your reply if single-source. Restructuring around it — promoting a leaf to a top-level branch, reshuffling siblings — is structural: show the proposed change, recommend waiting for corroborating interviews, and let the human decide (AP6: overreacting to n=1).

## Experience-map upkeep

After harvesting, refine `experience-map.md` from each snapshot's "Experience map slice" — extend or correct the affected step, surfacing conflicts rather than silently overwriting.

## Rationalizations

| Excuse | Reality |
|---|---|
| "The human asked me to add/restructure it" | Requests are input to the validity tests, not an override. Recommend; the human decides. |
| "We can tidy the tree later" | An invalid node misleads every reader the moment it lands. Keep it out and say why. |
| "The new branch fits the journey order" | Placement logic is not evidence. n=1 gets a leaf and a flag, not a reshuffle. |
| "I'll attach the solution somewhere reasonable" | Solutions attach only under the opportunity they address. No evidence → ask. |
