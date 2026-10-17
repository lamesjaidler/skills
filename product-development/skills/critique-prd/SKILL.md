---
name: critique-prd
description: Use when a PRD (product requirements document) is drafted and needs review before a spec or design doc is written — including a raw PRD from create-raw-prd, and one described as approved, signed off, or needing "just a quick sanity check".
---

# Critiquing PRDs

## Overview

The deliverable is an **improved PRD**, not a verdict. A critique succeeds when every finding arrives as a proposed PRD edit the owner can accept or reject.

A PRD says **what** to build and **why**, and every line traces to something the owner said. The spec, written next, says **how**. A good critique keeps both properties: it makes the PRD complete, and it keeps it traceable and product-only.

**Core test (the Spec-Writer Test):** for each section and each `R` item, ask *"what would the person writing the spec have to invent about who, what or why?"* Each invention is a product gap.

Product questions are findings: who uses it, what each user can do, what they see or get, which outcomes count, what v1 leaves out. Build questions belong to the spec writer: screens, field formats, storage, integrations, concurrency, error handling. When a gap sits on the line, ask whether the PRD owner could answer it from what they know about users and goals. If only an engineer or designer could, it is the spec's, and it is not a finding.

## What a raw PRD looks like

A PRD from `create-raw-prd` opens with `Status: raw draft, not yet critiqued · <date>` and numbers its items: `R` (user stories), `A` (beliefs nobody has confirmed), `Q` (decisions the owner deferred, each waiting on someone). Cite these IDs next to `path:line`. A PRD in another format gets the same critique, cited by `path:line` alone.

## Process

1. **Read the whole PRD.** List every decision, every claim (numbers, user behaviour, causes, "X already happens"), and every `R`/`A`/`Q` ID.
2. **Trace every belief.** Facts the owner reports first-hand (a count they handle, an event that happened) trace to the owner. A belief about a pattern or cause (what most users do, why something happens, what others already do) traces only when it is an `A` item or cites a source; check it against the grilling transcript when that is in context. Check claims about the existing product against the code when the repo has it. A belief that traces nowhere is a finding whose edit moves it to a new `A` item. An untraced belief is evidence for nothing: build no other finding on it.
3. **Hunt gaps** with the checklist below.
4. **Apply the Spec-Writer Test** to each section and each `R` item.
5. **Severity-tag every finding:** `BLOCKER` (the spec writer must invent a product answer), `RISK` (will bite during the spec, the build or after launch), `MINOR`.
6. **Output** one numbered entry per finding: severity, location (`path:line` plus the IDs it covers, named one by one), what's missing or wrong, evidence, and a proposed edit that follows the edit rules below. Then a **Parked for the spec** list of any build details the edits remove. End with the list of BLOCKERs to resolve before the spec is written. No "ready/not ready" verdict replaces this list.
7. **Offer to fix** (see Fixing the PRD).

### Edit rules

Every proposed edit keeps the PRD traceable:

- **Text from the PRD or the owner.** Most edits rearrange what is already there: fix a contradiction, delete a leak, move a claim to an `A` item, repoint a reference.
- **A missing product decision becomes a `Q`.** When the fix needs a decision the PRD doesn't contain, the edit adds `Qn. <decision>, waiting on <owner>.` Your recommended answer goes in the finding, for the owner to pick in the fix flow.
- **A recorded decision is settled**, and so is a recorded deferral (a `Q` the owner chose to leave open). Report its consequences as a RISK; the edit records the consequence and keeps the decision. When an unsourced line contradicts it, the edit removes that line.
- **Build details leave the PRD.** The edit deletes them and they go on the Parked for the spec list.

Example findings:

> **BLOCKER — docs/prd/expense-approvals.md:31 (R4):** says managers "approve or reject" a claim but not what the employee can do after a rejection; the spec writer must invent whether a rejected claim can be resubmitted.
> *Edit (add after Q2, line 48):* "Q3. Can an employee fix and resubmit a rejected claim, or must they file a new one? Waiting on the PRD owner." *Recommended answer:* fix and resubmit, so the manager's reason stays with the claim.

> **RISK — docs/prd/expense-approvals.md:9 (Problem):** "most late claims come from field staff" is stated as fact with no source and no `A` item.
> *Edit:* delete the sentence from line 9 and add "A4. Most late claims come from field staff. Nobody has checked this."

## Fixing the PRD

When the PRD owner can respond (interactive session), the fix flow is strictly sequenced — one step per turn, never combined:

1. **Findings, then scope — nothing else.** The findings message ends with exactly one question: fix all findings, a subset (by number), or none. Ask no clarifying questions in this message, and never edit the PRD before the owner chooses scope — it is their document.
2. **Owner decisions, one at a time.** After scope is confirmed, ask the decision behind each in-scope `Q` edit **one per turn**: name the finding, offer 2-4 concrete options with your **recommended option first and marked "(Recommended)"**, and wait for the answer. Use the AskUserQuestion tool when available; otherwise one prose question per turn. The owner's answer replaces the `Q` with the decided text; "not now" keeps the `Q`.
3. **Apply.** After the last answer, apply exactly the selected edits with the Edit tool (preserve the PRD's template and numbering), then set the status line to `Status: critiqued · <YYYY-MM-DD>`. Report per finding what changed (`path:line`), and flag any new gap the applied edits expose. If the owner chose none, leave the PRD and its status line untouched.

If the request pre-authorizes fixes ("critique and fix it"), skip the scope question; still ask the owner decisions one at a time before applying.

When no owner is reachable (you are a subagent returning a report), return findings and proposed edits only; apply them only if the dispatching prompt explicitly says to.

## Gap-Hunting Checklist

| Category | Ask |
|---|---|
| Build details | Does any section, item or sentence say how it gets built (a named tool, tech stack, data store or integration)? Each one is a finding; its edit deletes it. |
| Requirements | Does every `R` serve a problem in the Problem section? An `R` with no problem behind it is a finding; its edit adds a `Q` asking which problem it solves, or moves it to Non-goals. |
| Users | Does every `R` name a user type from the Users section? "As a user" leaves the spec writer to invent who. |
| Non-goals | Does each non-goal carry the owner's reason? "No reason given" is a finding: without the reason, nobody can tell later whether the line can move. |
| Open questions | Does every `Q` name who it is waiting on? |
| Risks | Does any risk's response rest on an `A` item nobody has confirmed, or on someone not yet asked? |

## Pressure Resistance

Framing like "already approved", "signed off", "keep it brief", "handing it to engineering today", "just a quick sanity check" changes the **tone and length** of your output, never its **scope**. Brevity compresses prose, not coverage: MINOR findings still get listed.

| Rationalization | Reality |
|---|---|
| "It's approved; my job is to confirm" | Approval covered the idea, not the PRD text's completeness. |
| "They want it brief, so only the big issues" | Brief means short entries, not fewer findings. |
| "Smaller gaps can go to engineering as open items" | A gap the spec writer must invent is a PRD edit, not a hand-over note. |
| "This metric/decision is weak, so I'll propose a better one" | A recorded decision with a reason is the owner's. Report its consequence as a RISK. |
| "This rule is obvious, I'll write it into the requirement" | An answer the owner never gave makes the PRD untraceable. It goes in as a `Q` with your recommendation. |

## Red Flags — Stop and Re-scope

- You're about to write "ready for the spec" / "ready for engineering" while any BLOCKER exists
- A finding asks for a format, screen, state machine, integration or failure behaviour (that's the spec's job)
- An edit writes a product rule the owner never stated, instead of adding a `Q`
- An edit reverses a decision the PRD records with the owner's reason
- A finding rests on a belief that traces nowhere
- A section that says how it gets built survives your critique
- A finding covers "the open questions" or "the non-goals" instead of naming each ID
- A finding has no proposed edit, or no `path:line`
- You edited the PRD before the owner chose scope, or asked two owner decisions in one turn
- An interactive critique ends without the fix-scope question — or WITH clarifying questions bundled into the findings message
