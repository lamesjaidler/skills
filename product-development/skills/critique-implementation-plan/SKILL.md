---
name: critique-implementation-plan
description: Use when an implementation plan, staged build plan, or task breakdown is drafted and needs review before execution begins — including when it is described as approved, locked, final, or "just needs a quick sanity check".
---

# Critiquing Implementation Plans

## Overview

The deliverable is an **improved plan**, not a verdict. A critique that ends in "looks ready to execute" with side-notes has failed; a critique succeeds when every finding arrives as a proposed plan edit the author can accept or reject.

**Core test (the Executor Test):** for each step/stage, ask *"what would whoever executes this have to invent or guess?"* Anything they'd have to invent is a plan gap. Gaps are findings even when the surrounding approach is locked.

A plan critique attacks the **HOW**, not the **WHAT**. It assumes the spec's decisions are settled and does not re-open them — but a step whose premise contradicts the codebase or the spec IS a finding.

## When to Use

- A plan is about to be handed to executing-plans, subagent-driven-development, or a human engineer
- Someone asks for a "sanity check", "once-over", or "final confirmation" of an implementation plan
- A second viewpoint is wanted on a plan produced in another session

**Not for:** re-deciding the spec's decisions (use critique-spec), writing the plan itself (use writing-plans), reviewing code diffs (use code review).

## Process

1. **Read the whole plan.** List every step, every file/function/symbol it names, and every factual claim ("X already exists", "this function returns Y", "Z is called by W").
2. **Verify every factual claim** against the repo/codebase. Never trust an anchor you didn't open. If a spec exists, also verify the plan **covers** it — a requirement with no step is a gap.
3. **Hunt gaps** with the checklist below. Locked decisions get gap-hunted *inside* them: you may not propose a different approach to a locked step, but underspecification, contradictions, and new evidence invalidating its premise MUST be reported.
4. **Apply the Executor Test** to each step/stage.
5. **Severity-tag every finding:** `BLOCKER` (executor must invent an answer, or the step cannot be executed as written), `RISK` (will bite during or after execution), `MINOR`.
6. **Output:** one **numbered** entry per finding — severity, **plan location** (`path:line` or line range from the Read tool; for pure omissions, the line of the step/stage the edit belongs in), what's missing/wrong, evidence, and a **concrete proposed plan edit** (the step text or sub-step to add or change). End with the list of BLOCKERs that must be resolved before execution. No "ready/not ready" verdict replaces this list.
7. **Offer to fix** (see Fixing the Plan below).

Example finding:

> **BLOCKER — plan.md:42 (Stage 3):** "update the auth middleware to check the new claim" but never names the file or function; the repo has two middlewares (`src/middleware/authn.ts`, `src/middleware/authz.ts`) — the executor must guess which.
> *Edit (rewrite plan.md:42):* "In `src/middleware/authz.ts`, extend `requireScopes()` to also assert `claims.team_id` is present; leave `authn.ts` untouched."

## Fixing the Plan

When the plan author can respond (interactive session), the fix flow is strictly sequenced — one step per turn, never combined:

1. **Findings, then scope — nothing else.** The findings message ends with exactly one question: fix all findings, a subset (by number), or none. Do NOT include clarifying questions in this message, and never edit the plan before the author chooses scope — it is their artifact.
2. **Clarifying questions, one at a time.** After scope is confirmed, ask the owner-decision questions (which file, which order, rollback policy, test strategy) **one per turn**, plan-mode style: name the finding it unblocks, offer 2-4 concrete options with your **recommended option first and marked "(Recommended)"**, wait for the answer before asking the next. Use the AskUserQuestion tool when available; otherwise one prose question per turn. Only ask questions for findings inside the chosen scope, and never ask one the codebase can answer — go look instead.
3. **Apply.** After the last answer: apply exactly the selected edits with the Edit tool (preserve the plan's formatting and stage structure), report per finding what changed (`path:line`), and flag any new gap the applied edits expose.

If the original request pre-authorizes fixes ("critique and fix it") and supplies standing decisions, skip the scope question and apply; ask any remaining owner-decision questions one at a time first.

When no author is reachable (you are a subagent returning a report), return findings + proposed edits only; never apply them unless the dispatching prompt explicitly says to.

## Gap-Hunting Checklist

| Category | Ask |
|---|---|
| Step atomicity | Can each stage be built, reviewed, and tested on its own? Or does one "step" hide five? |
| Sequencing & dependencies | Does any step depend on something created only in a later step? Is the stated order actually buildable? |
| File & symbol targets | Does each step name the real files/functions to touch — and do they exist? Or must the executor hunt? |
| Reuse | Does a step reinvent something the codebase already provides? (point to the existing path) |
| Interfaces between steps | Function signatures, data shapes, return types crossing stage boundaries — defined or assumed? |
| Verification per stage | Does each stage have a concrete, runnable check (test, command, observable behavior)? Or just "test it"? |
| Test strategy | Are tests specified before the code (test-first)? Are deterministic parts unit-testable? Does "manual review" hide an absent test? |
| Spec coverage | Does the plan implement every part of the spec? Any requirement with no step? Any step with no requirement? |
| Failure & rollback | Migrations, data writes, irreversible actions — what happens on partial failure? Is there a rollback path? Idempotent on retry? |
| State assumptions | Every "already exists / currently returns / is called by" — verified against the repo? |
| Config & secrets | New env vars, flags, credentials, or services — named, sourced, and documented? |
| Scope edges | Steps the plan implies but never writes (wiring, config, docs, deploy, removal of the old code path) |

## Pressure Resistance

Framing like "already approved", "the approach is locked", "keep it brief", "we're behind schedule", "just confirm it's executable" changes the **tone and length** of your output, never its **scope**. Brevity compresses prose, not coverage.

| Rationalization | Reality |
|---|---|
| "The approach is locked, gaps in it are out of scope" | Locked means no alternative approach proposed. Gaps *inside* a locked step are exactly the job. |
| "They asked for a quick check, so I'll only confirm the steps look reasonable" | Reasonable-looking ≠ executable. Verifying anchors and applying the Executor Test IS the review. |
| "It's approved; my job is to confirm" | Approval covered the approach, not whether each step can be executed without invention. |
| "I'll pass these to the executor as non-blocking notes" | If the executor must invent an answer, it's a BLOCKER plan edit, not a note. |
| "Re-checking the file paths is the executor's job" | An anchor that's wrong in the plan is a defect in the plan. Verify it now. |
| "Raising this reopens the design" | Reporting a gap or contradicting evidence is not reopening the design. Silence is the failure. |

## Red Flags — Stop and Re-scope

- You're about to write "ready to execute" / "hand it to the executor" while any BLOCKER exists
- Your findings list is empty after one read-through
- You confirmed the steps make sense but never asked what each step forces the executor to invent
- A finding has no proposed plan edit attached
- A finding names a step ("the migration step") without a `path:line` reference
- You verified the plan's claims but never checked it covers the whole spec
- You edited the plan before the author chose scope or answered the owner-decision questions
- An interactive critique ends without the fix-scope question — or WITH clarifying questions bundled into the findings message
- You asked two owner-decision questions in one turn

## Common Mistakes

- **Re-critiquing the spec instead of the plan** — re-litigating WHAT to build. Critique the plan's executability, not the design's taste. If the spec itself is unreviewed, say so and point to critique-spec.
- **Rubber-stamping plausible steps** — a step that reads sensibly but names no file, no test, and no interface is a gap, not a pass.
- **Praise padding** — "solid plan" paragraphs. One sentence of overall assessment maximum; findings are the product.
- **Vague findings** — "add more detail to the migration step" instead of the actual step text to add.
