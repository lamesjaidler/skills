---
name: testing-assumptions
description: Use when a solution needs de-risking before building, when the team says "let's validate this idea" or plans an MVP, when assumptions need surfacing or mapping, when designing a quick test, or when recording assumption test results.
---

# Testing Assumptions

## Overview

De-risk the 3 candidate solutions on `ost.md` by testing their riskiest assumptions — never by building one. Framing: reducing risk, not proving truth — a test buys evidence about an assumption, not idea validation (AP4). "A quick MVP to validate it" routes here: the 1–2-day assumption test IS the quick version. File paths and outline format: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`; anti-patterns cited (AP3, AP4, AP9): `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

Hard rule, verbatim: **Always ≥3 solutions compared in parallel; never validate one idea at a time.** No "strongest one first": a single candidate invites confirmation bias and escalation of commitment (AP3), and buildability is effort — never a reason to drop peers untested. Every step runs on all 3 together.

## 1. Surface (per solution, aim ~20–30 assumptions)

Write `discovery/<outcome-slug>/assumptions/<solution-slug>.md`, one file per candidate:

- **Story-map** the customer's steps using the solution — each step assumes something.
- **Pre-mortem:** "It's 6 months later and this failed — why?"
- **Walk the tree:** does this solution really address this opportunity, and this opportunity this outcome?
- Bucket every assumption under the 5 categories: **desirability / viability / feasibility / usability / ethical**. State each so it can be false.

A loose assumption belongs to the candidate solution(s) depending on it — file it there.

## 2. Map

Per solution: a 2x2 of importance × evidence, in the file. Only the top-right (high importance, weak evidence) is tested now.

## 3. Test

Fill `${CLAUDE_PLUGIN_ROOT}/templates/assumption-test-spec.md` per top-right assumption, embedded in the solution's file.

- Techniques: unmoderated test, one-question survey, prototype, fake-door, wizard-of-oz, data mining.
- Simulate one **moment** of the experience where the participant behaves consistently or inconsistently with the assumption. Observed behavior decides; stated opinion counts as zero (AP9).
- **1–2 days, small n.** Small and weak first; bigger/stronger only for assumptions that keep mattering.
- Criterion pre-set, raw numbers: "at least 3 of 10", never percentages, fixed before data collection, right audience named (AP9).
- When a solution's test spec is delivered, flip its `ost.md` status: `candidate` → `testing`.

## 4. Record results

- Fill the spec's Result section: observed raw count, date, verdict against the criterion as written. The bar stands after data; "the test measured the wrong thing" feeds the next spec, not this verdict.
- Recommend the next move compare-and-contrast, with reasoning: **iterate the test stronger** vs **prune this solution** vs **revisit the opportunity**.
- The human decides — in a one-shot run, end by asking. Only then update `ost.md`: `pruned` or `advanced`. Statuses: only `candidate | testing | pruned | advanced`; every status change edits the status word alone — reasoning, results, history live in the assumptions file, never `ost.md`.
- New solution ideas mid-cycle go through `ideating-solutions` against the tree, never spliced into a running test.

## Rationalizations

| Excuse | Reality |
|---|---|
| "Quick MVP of the strongest one to validate it" | Idea testing (AP4), one at a time (AP3). Surface assumptions for all 3; test the riskiest in 1–2 days. |
| "Only this one is buildable standalone" | Buildability is effort. All 3 advance together — a test simulates the integration it lacks. |
| "Two more said they'd do it if reminded — really 6 of 10" | Stated intent is not behavior (AP9). The count stands; verdict: criterion missed. |
| "n=10 is too thin — run a multi-week field study" | Small and weak first; scale up only if the assumption keeps mattering. |
| "Mark it mvp-in-progress" / "log the move under Target history" | No such status, no log. Only `candidate \| testing \| pruned \| advanced`. |
