---
name: continuous-interviewing
description: Use when preparing for a customer interview, writing interview questions or a discussion guide, or when an interview transcript, recording, or notes need to be synthesized after the fact. Not for live in-interview assistance.
---

# Continuous Interviewing

## Overview

Interviewing is the keystone habit of continuous discovery: weekly story-based interviews run by the product trio itself, each distilled into a one-page snapshot the team shares. Two modes, keyed on what is in hand:

- **No transcript or notes in hand → prep mode.** Build a discussion guide.
- **Transcript, recording, or notes provided → snapshot mode.** Synthesize them into a snapshot.
- **Live in-interview assistance is out of scope.** This skill works before and after the conversation; if asked for real-time help mid-interview, say so and stop.

Anti-patterns cited below live in `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.

## Prep mode — build the discussion guide

Questions collect specific past stories, because asking customers what they want collects unreliable predictions (AP1). A usable question names one concrete past instance: "Tell me about the last time you…"

1. Read `discovery/<outcome-slug>/experience-map.md` (path rules: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`). If no `discovery/<outcome-slug>/` dir exists at all, the outcome comes first: point the user to the `defining-outcomes` skill (it creates the dir), and until it has run, deliver any draft map and guide in your reply only — `discovery/` stays untouched, no invented slug. If the dir exists but the map does not, draft one with the user — sketch the steps of the current customer experience as they understand it, save it, then continue.
2. Pick the slice of the map the trio most needs to learn about; state which slice and why.
3. Write story-elicitation questions, each anchored to a named slice: "Tell me about the last/most recent time you <did that slice's activity>."
4. Under each question, add follow-up scaffolds that walk the story's timeline: "Take me back to the start." "What happened next?" "What did you do then?"

**Done when** every question asks for a specific past instance tied to a map slice, and zero questions ask the participant to predict, choose, rank, imagine, wish, or compare — that includes "what would you miss", "magic wand", and "which app does this better". Those are AP1 in disguise: they sample opinion, not behavior. Deliver the guide itself; how to steer the live conversation is out of scope, and the guide should say so.

## Snapshot mode — synthesize the interview

The snapshot, not the raw notes, is the unit of sharing and synthesis (AP11): one page, in the template's exact sections.

1. Read the transcript or notes in full.
2. Fill `${CLAUDE_PLUGIN_ROOT}/templates/interview-snapshot.md` — every section, exact headings — and write it to `discovery/snapshots/YYYY-MM-DD-<participant>.md` (today's date, participant pseudonym).
3. **Vivid quote:** the one sentence, in the participant's exact words, the team will remember.
4. **Opportunities heard:** each a need, pain point, or desire quoted or closely paraphrased in the participant's own words — "I never know which project code to bill." Feature ideas the transcript suggests ("add smart code suggestions") are solutions; they belong in the solution space later, not in this file.
5. **Source line:** tag the evidence type (interview | sales call | support ticket | app review) and link the transcript or file.

**Done when** every template section is filled and every opportunity reads as a sentence the participant could have said.

## Cadence

Interviews happen weekly and are conducted by the product trio itself — not batched into a research phase or handed off to a research team (AP2). Automate recruiting (in-product intercepts, standing calendar links) so no single person is the bottleneck (AP12). After each interview, share the snapshot, never the raw notes (AP11).
