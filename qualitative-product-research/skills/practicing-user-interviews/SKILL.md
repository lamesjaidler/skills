---
name: practicing-user-interviews
description: Use when someone wants to practice, rehearse, or role-play a qualitative user-research, customer-discovery, or user-interview conversation for their app or product before talking to real users, or wants their interview questions coached. Triggers include "practice user research", "mock interview", "be a potential user I can interview", "roleplay a user", "coach my interview questions".
---

# Practising User Interviews

## Overview

Help someone rehearse a qualitative user-research interview by playing a realistic potential user of *their* app and coaching their questions in real time. Core principle: ground the persona in the actual repo, and steer every question toward **specific past behaviour** instead of opinions, hypotheticals, and pitched solutions.

**REQUIRED BACKGROUND:** Read the shared `interview-principles.md` at the plugin root (`${CLAUDE_PLUGIN_ROOT}/interview-principles.md`) before coaching. It holds the question leaks, deepening techniques, need-vs-solution discipline, and persona-realism rules you apply throughout. Do not coach from memory alone.

## When to use

- "I want to practice user research / customer-discovery interviews for this app."
- "Be a user I can interview and coach my questions as we go."
- Rehearsing before real user interviews; sharpening interview technique.

**Not for:** writing a research plan or survey, analysing real interview transcripts, or generating questions without practice.

**Related:** for a *real* interview rather than rehearsal — paste replies, get the next question to ask — use `qualitative-product-research:live-interview-copilot`.

## Workflow

### 1. Read the repo first — never skip

Inspect README, `docs/`, onboarding/help copy, product/marketing copy, key features, and package manifests. Establish: what the app does, the job it serves, and 1–3 plausible target-user segments — grounded in evidence you actually found, not assumed from the request.

Cross-check sources; do not trust one doc. READMEs go stale — if the README and the onboarding copy, templates, or code disagree, weight the living evidence (what the app actually does today) over the README's description.

> Red flag: about to name a persona without having read the repo. Stop and read.

### 2. Propose ONE concrete persona, then offer the choice

Present a single, specific persona derived from the repo: name, role, context, the job they'd hire the app for, tech-comfort, and relationship to the product (prospective / new / regular). State *why the repo implies this user*. Then offer the user:

- use this persona, **or**
- tweak it (harder, busier, different segment), **or**
- describe their own, **or**
- see a different option.

### 3. Set session parameters

Confirm before starting: which feature/job to focus on, interview type (discovery vs concept-test), and coaching cadence (after every question / only when they drift / at the end).

### 4. Run the loop with two separated hats

Keep the roles in distinct, labelled blocks — never blend them in one block:

- **[Coach]** — out of character.
- **[PersonaName]** — in character.

Default loop (coach-every-question):

1. User asks a question.
2. **[Coach]**: verdict (strong / weak), name the specific leak(s) from `interview-principles.md`, give one tightened rewrite that **mirrors the user's own words**.
3. User asks the improved (or their own) question.
4. **[PersonaName]**: answer realistically per the persona-realism rules.

Discipline (these are where it goes wrong):

- A weak question earns a weak — hollow or agreeable — in-character answer. Let the failure show; do not rescue it with a useful answer.
- The persona never breaks character to coach, never gives clean PM-style feedback, never volunteers the perfect feature.
- **Quarantine solutions:** if the user pitches a feature mid-interview, coach it — do not let the persona validate it.

### 5. Synthesise on request or at the end

Separate **findings (needs)** from **solutions**. Surface the workarounds the persona revealed. Flag what is still unknown, and remind that one interview is n=1.

## Question leak quick-reference

| Smell | Why it fails | Fix |
|---|---|---|
| "Do you like X?" (opinion) | invites politeness, no evidence | "Tell me about the last time you…" |
| "Would you use…" (hypothetical) | people mispredict + over-promise | ask what they already do |
| Feature named / leading | anchors them, hides what matters | let them narrate; follow their lead |
| "usually / what do you prefer" (generalisation) | tidy fiction | get one instance; you generalise |
| Two questions at once | ambiguous answer | one at a time |
| "Would it help if we added Y?" (solution) | contaminates data, demand effect | probe the problem; quarantine solutions |

Full detail, deepening techniques, and bad→good rewrites: `interview-principles.md`.

## Common mistakes

- Inventing a generic persona without reading the repo.
- A persona that is too articulate and helpful — sounds like a product manager, not a real user.
- Coaching that says "good question" without naming the leak or giving a rewrite.
- Rewrites that paraphrase instead of mirroring the user's exact words.
- Letting a pitched solution get validated in character.
- Blending coach and persona in one block.

## Red flags — stop

- Proposing a persona before reading the repo.
- Persona giving comprehensive, tidy product feedback.
- Rewarding a leading or hypothetical question with a confident, useful answer.
