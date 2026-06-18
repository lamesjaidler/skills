---
name: critique-spec
description: Use when a spec, design doc, or PRD is drafted and needs review before implementation planning — including when it is described as approved, locked, final, or "just needs a quick sanity check".
---

# Critiquing Specs

## Overview

The deliverable is an **improved spec**, not a verdict. A critique that ends in "looks ready" with side-notes has failed; a critique succeeds when every finding arrives as a proposed spec edit the author can accept or reject.

**Core test (the Planner Test):** for each section/stage, ask *"what would an implementation planner have to invent here?"* Anything they'd have to invent is a spec gap. Gaps are findings even when the surrounding decision is locked.

## When to Use

- A spec/design doc is about to be handed to writing-plans (or any implementation-planning step)
- Someone asks for a "sanity check", "once-over", or "final confirmation" of a design doc
- A second viewpoint is wanted on a spec produced in another session

**Not for:** reviewing code diffs (use code review), generating the design itself (use brainstorming), re-deciding settled trade-offs.

## Process

1. **Read the whole spec.** List every decision it makes and every factual claim (file paths, branches, contracts, "X already exists").
2. **Verify every factual claim** against the repo/codebase. Never trust an anchor you didn't open.
3. **Hunt gaps** with the checklist below. Locked decisions get gap-hunted *inside* them: you may not propose an alternative to a locked decision, but underspecification, contradictions, and new evidence invalidating its premise MUST be reported.
4. **Apply the Planner Test** to each stage/step.
5. **Severity-tag every finding:** `BLOCKER` (planner must invent an answer), `RISK` (will bite during or after implementation), `MINOR`.
6. **Output:** one **numbered** entry per finding — severity, **spec location** (`path:line` or line range from the Read tool; for pure omissions, the line of the section the edit belongs in), what's missing/wrong, evidence, and a **concrete proposed spec edit** (the sentence/row to add or change). End with the list of BLOCKERs that must be resolved before handoff. No "ready/not ready" verdict replaces this list.
7. **Offer to fix** (see Fixing the Spec below).

Example finding:

> **BLOCKER — spec.md:28 (Decision #4):** says "stored in Firestore" but never names the path or doc ID; a planner must invent it.
> *Edit (add to spec.md:36, Read contract):* "Artifact stored at `…/teams/{team_id}/feedback_instructions/current` (single doc, overwritten per compile)."

## Fixing the Spec

When the spec author can respond (interactive session), the fix flow is strictly sequenced — one step per turn, never combined:

1. **Findings, then scope — nothing else.** The findings message ends with exactly one question: fix all findings, a subset (by number), or none. Do NOT include clarifying questions in this message, and never edit the spec before the author chooses scope — it is their artifact.
2. **Clarifying questions, one at a time.** After scope is confirmed, ask the owner-decision questions (fail-open vs fail-loud, data policy, naming) **one per turn**, plan-mode style: name the finding it unblocks, offer 2-4 concrete options with your **recommended option first and marked "(Recommended)"**, wait for the answer before asking the next. Use the AskUserQuestion tool when available; otherwise one prose question per turn. Only ask questions for findings inside the chosen scope, and never ask one the codebase can answer — go look instead.
3. **Apply.** After the last answer: apply exactly the selected edits with the Edit tool (preserve the spec's formatting and table structure), report per finding what changed (`path:line`), and flag any new gap the applied edits expose.

If the original request pre-authorizes fixes ("critique and fix it") and supplies standing decisions, skip the scope question and apply; ask any remaining owner-decision questions one at a time first.

When no author is reachable (you are a subagent returning a report), return findings + proposed edits only; never apply them unless the dispatching prompt explicitly says to.

## Gap-Hunting Checklist

| Category | Ask |
|---|---|
| Storage & shape | Every artifact: where does it live, what fields, what metadata? |
| Identifiers | Every ID referenced: which ID exactly? (doc ID vs inner field — classic bug seed) |
| Failure semantics | Missing data, malformed input, fetch failure, empty result: fail open or loud? |
| Contradictions | Do any two statements in the spec (or spec vs data contract) conflict? |
| Lifecycle | Concurrency, retries, ordering, staleness — decided or accidental? |
| Security & data | Secrets, PII, real data in fixtures/version control, unauthenticated cost-bearing endpoints |
| Naming | Collisions with existing concepts in the codebase |
| Verification | Is each claim of behavior actually checkable? Are deterministic parts unit-testable? Does "manual review" hide an absent test strategy? |
| Adjacent paths | Sibling code paths the spec touches but doesn't mention (refinement flows, alternate branches) |

## Pressure Resistance

Framing like "already approved", "decisions are locked", "keep it brief", "we're behind schedule", "just confirm it's ready" changes the **tone and length** of your output, never its **scope**. Brevity compresses prose, not coverage.

| Rationalization | Reality |
|---|---|
| "Decisions are locked, gaps in them are out of scope" | Locked means no alternatives proposed. Gaps *inside* a locked decision are exactly the job. |
| "They asked for a quick check, so I'll only verify facts" | Fact-checking is step 2 of 6, not the review. |
| "It's approved; my job is to confirm" | Approval covered the decisions, not the spec text's completeness. |
| "I'll pass these to the planners as non-blocking notes" | If a planner must invent an answer, it's a BLOCKER spec edit, not a note. |
| "Raising this reopens a settled debate" | Reporting a gap or contradicting evidence is not reopening a debate. Silence is the failure. |

## Red Flags — Stop and Re-scope

- You're about to write "ready for planning" / "send it to planning" while any BLOCKER exists
- Your findings list is empty after one read-through
- You verified claims but never asked what's *missing*
- A finding has no proposed spec edit attached
- A finding names a section ("the storage decision") without a `path:line` reference
- You edited the spec before the author chose scope or answered the owner-decision questions
- An interactive critique ends without the fix-scope question — or WITH clarifying questions bundled into the findings message
- You asked two owner-decision questions in one turn

## Common Mistakes

- **Redesigning instead of critiquing** — proposing a different architecture for a locked decision. Critique the spec's completeness, not its taste.
- **Praise padding** — "strong spec" paragraphs. One sentence of overall assessment maximum; findings are the product.
- **Vague findings** — "add more detail on storage" instead of the actual sentence/row to add.
