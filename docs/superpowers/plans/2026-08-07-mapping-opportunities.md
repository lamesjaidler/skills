# `mapping-opportunities` Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `mapping-opportunities` skill to the `qualitative-product-research` plugin that turns a product outcome — plus whatever evidence exists — into a structured, evidence-tagged opportunity map, and refuses to dress hypotheses up as findings.

**Architecture:** Two new Markdown files. `opportunity-principles.md` sits at the plugin root as a shared reference (mirroring the existing `interview-principles.md`), read at runtime via `${CLAUDE_PLUGIN_ROOT}`; `skills/mapping-opportunities/SKILL.md` holds the workflow and stays ~100 lines. The skill is discipline-enforcing, so it is built with the RED-GREEN-REFACTOR cycle from `superpowers:writing-skills`: three subagent scenarios are run and recorded **before** either file is written, the files are written against those recorded failures, then loopholes are closed and the scenarios re-run.

**Tech Stack:** Markdown, YAML frontmatter, Claude Code plugin manifests (JSON), `jq`, `bash`. No build step, no runtime code.

## Global Constraints

Every task's requirements implicitly include this section.

- **Iron Law (`superpowers:writing-skills`):** no skill without a failing test first. Tasks 1 must complete and its baselines be recorded before Task 2 or 3 writes a word of `SKILL.md` or `opportunity-principles.md`.
- **Validator invariant 1:** a skill's directory name must equal the `name:` in its `SKILL.md` frontmatter. Here both are `mapping-opportunities`.
- **Validator invariant 2:** `plugin.json` `name` must equal the plugin's entry `name` in `marketplace.json`. Here both are `qualitative-product-research`.
- **`marketplace.json` carries no `version` field.** Do not add one.
- **Version bump is the cache-refresh mechanism**, not bookkeeping. `qualitative-product-research/.claude-plugin/plugin.json`: `0.1.0` → `0.2.0`. There is no `--force` for `claude plugin update`.
- **`SKILL.md` house style:** 70–105 lines. Heavy shared reference goes in the plugin-root file, not the skill.
- **`description:` frontmatter states triggering conditions only** — no workflow summary. Use the exact text in Task 3 verbatim.
- **Map output path is relative to the consuming project's root:** `docs/discovery/<outcome-slug>-opportunity-map.md`. Never this marketplace repo.
- **Out of scope for the skill:** the solution space, assumption tests, ideation, prioritisation frameworks, running interviews.
- **British spelling in prose** — the sibling skills use "behaviour", "synthesise", "prioritisation", "rationalise". Match them.
- **`bash scripts/validate-marketplace.sh` is the whole of CI.** Requires `jq`. Run before every commit that touches a manifest or a `SKILL.md`.
- **Git:** work stays on `feat/mapping-opportunities-skill`. Do not push, merge, rebase, or open a PR without explicit instruction from the user.

**Assumption stated:** test scenarios and their recorded transcripts are committed to `docs/superpowers/tests/mapping-opportunities/`. They live outside any plugin directory, so they do not ship with the plugin and do not affect the validator. Rationale: the scenarios *are* the skill's test suite — REFACTOR re-runs them, and so will anyone editing the skill later.

---

## File Structure

| File | Responsibility |
|---|---|
| `docs/superpowers/tests/mapping-opportunities/scenario-1-generative.md` | RED/GREEN test: outcome only, no evidence. |
| `docs/superpowers/tests/mapping-opportunities/scenario-2-evidence.md` | RED/GREEN test: outcome + two transcripts. |
| `docs/superpowers/tests/mapping-opportunities/fixtures/interview-p3.md` | Fabricated transcript fixture for scenario 2. |
| `docs/superpowers/tests/mapping-opportunities/fixtures/interview-p7.md` | Fabricated transcript fixture for scenario 2. |
| `docs/superpowers/tests/mapping-opportunities/scenario-3-pressure.md` | RED/GREEN test: hypothesis-only tree + "rank these". The load-bearing one. |
| `docs/superpowers/tests/mapping-opportunities/baseline-results.md` | RED evidence: verbatim subagent output without the skill. |
| `docs/superpowers/tests/mapping-opportunities/green-results.md` | GREEN + REFACTOR evidence: verbatim output with the skill. |
| `qualitative-product-research/opportunity-principles.md` | Shared reference: outcome types, framing rules, anti-slop discipline, evidence tags, map format. Consumed via `${CLAUDE_PLUGIN_ROOT}`. |
| `qualitative-product-research/skills/mapping-opportunities/SKILL.md` | The skill: activation, 5-step workflow, quick reference, rationalisation table, red flags. |
| `qualitative-product-research/.claude-plugin/plugin.json` | Version + keywords. |
| `.claude-plugin/marketplace.json` | Plugin description. |
| `README.md`, `CHANGELOG.md` | User-facing docs. |

---

### Task 1: RED — write the three scenarios and record baseline failures

**Files:**
- Create: `docs/superpowers/tests/mapping-opportunities/scenario-1-generative.md`
- Create: `docs/superpowers/tests/mapping-opportunities/scenario-2-evidence.md`
- Create: `docs/superpowers/tests/mapping-opportunities/fixtures/interview-p3.md`
- Create: `docs/superpowers/tests/mapping-opportunities/fixtures/interview-p7.md`
- Create: `docs/superpowers/tests/mapping-opportunities/scenario-3-pressure.md`
- Create: `docs/superpowers/tests/mapping-opportunities/baseline-results.md`

**Interfaces:**
- Consumes: nothing.
- Produces: three scenario prompt files, run verbatim as subagent prompts by Tasks 4 and 5; and `baseline-results.md`, whose recorded rationalisations are the **only** permitted source for the rationalisation table in Task 5.

**Why this is first:** `superpowers:writing-skills` Iron Law. Writing the skill before the baseline means you document what *you* think needs preventing, not what actually happens.

- [ ] **Step 1: Write scenario 1 — the generative case**

Create `docs/superpowers/tests/mapping-opportunities/scenario-1-generative.md`:

````markdown
# Scenario 1 — Generative case

Run this text verbatim as a subagent prompt (`subagent_type: "general-purpose"`).

---

IMPORTANT: This is a real task from a real product team. Produce the actual deliverable — not a description of how you would approach it, and not clarifying questions.

I'm a PM at an indie music distribution startup. Our outcome for next quarter:

> Independent music producers want to increase the size of their listener base.

Find the opportunities for this outcome so we know what to build. I need the opportunity space written out.

Do not read any files in this repository — answer from your own knowledge.

---

## Predicted baseline failure

15+ generic bullets; feature names ("analytics dashboard", "playlist pitching tool") presented as opportunities; no assumption tagging; no critique of the outcome as a customer desire rather than a product outcome.
````

- [ ] **Step 2: Write the two transcript fixtures for scenario 2**

Create `docs/superpowers/tests/mapping-opportunities/fixtures/interview-p3.md`:

````markdown
# P3 — Mara, 29, bedroom producer (lo-fi / downtempo), Lisbon

Interviewed 2026-07-14. Distributes via our platform, ~4 releases in the last 18 months.

**Q: Walk me through your last release, start to finish.**

Finished the master on a Tuesday, sat on it for nine days because I hadn't done the artwork. Uploaded Thursday night. Then I did the thing where you paste the link everywhere — Instagram story, two Discords, the subreddit, a WhatsApp group of producer friends. Took me most of Friday.

**Q: Most of Friday — what were you doing in that time?**

Rewriting the same post four times because each place wants it different. Reddit hates a bare link, Instagram needs a vertical clip so I had to cut one, Discord you just drop it. I made a vertical clip in CapCut at 1am. That's the bit I hate. I burned an evening and I think it got me six plays.

**Q: How did you know it got six plays?**

I didn't really. I refreshed the dashboard a lot. The numbers went up but I couldn't tell you if that was the Reddit post or the friend who shared it or just the algorithm. It's all one number.

**Q: Tell me about the last time a release went well.**

The one before. A playlist picked it up — I still don't know which one or how. I got a spike and then it stopped. I tried to work out what I'd done differently and I genuinely couldn't. I looked back at my posts and they were the same posts.

**Q: What do you do instead, when you can't tell?**

Honestly I just release more. If I can't tell what worked, more shots is the only lever I've got. Which is exhausting and I know it's not a strategy.

**Q: Anything you've paid for?**

I paid for a promo service once, £40. Got a spreadsheet of playlist emails. I emailed maybe fifteen and gave up. Nobody replied.
````

Create `docs/superpowers/tests/mapping-opportunities/fixtures/interview-p7.md`:

````markdown
# P7 — Dan, 41, part-time producer (house), Leeds

Interviewed 2026-07-21. Day job in logistics. Releases roughly quarterly.

**Q: Walk me through your last release day.**

Release day itself is nothing, it's the two weeks before. I do the whole run-up — teaser clip, pre-save link, message the DJs I know. Then release day I'm at work, so I check my phone at lunch and that's it.

**Q: Tell me about messaging the DJs.**

I've got a list in my Notes app. Maybe thirty names. I go through and message them individually because a group message reads as spam. Last time I got through eleven before I ran out of evening. Two replied. One played it.

**Q: What happened after the one who played it?**

That's the thing — nothing that I could see. Someone told me later he'd played it at a night in Sheffield. There's no line from that to a number on my screen. My stats went up 200 that week and I have no idea if that was him.

**Q: You said your stats went up 200. What did you do with that?**

Nothing. What would I do? It's a number that went up. I can't tell you who those people are or whether they'll come back for the next one. I'd love to know if they're the same 200 every time or 200 new ones.

**Q: Have you tried to find out?**

I exported the CSV once. It's geography and device. Not useful. I went back to just looking at the top-line number.

**Q: What's the most annoying part of all this?**

That the promo work and the music are the same job now and I only wanted one of them. I've got maybe six hours a week. If I spend four of them messaging DJs that's four hours I didn't spend producing.
````

- [ ] **Step 3: Write scenario 2 — the evidence case**

Create `docs/superpowers/tests/mapping-opportunities/scenario-2-evidence.md`:

````markdown
# Scenario 2 — Evidence case

Run this text verbatim as a subagent prompt. Substitute `<REPO>` with the absolute path to this repository.

---

IMPORTANT: This is a real task from a real product team. Produce the actual deliverable — not a description of how you would approach it.

I'm a PM at an indie music distribution startup. Our outcome:

> Independent music producers want to increase the size of their listener base.

We ran two discovery interviews last month. Read ONLY these two files, and no other files in the repository:

- `<REPO>/docs/superpowers/tests/mapping-opportunities/fixtures/interview-p3.md`
- `<REPO>/docs/superpowers/tests/mapping-opportunities/fixtures/interview-p7.md`

Build us the opportunity space from them.

---

## Predicted baseline failure

Jumps straight to an amalgamated tree with no per-interview synthesis; invents opportunities neither participant raised; relabels "I burned an evening and I think it got me six plays" into PM-speak like "inefficient cross-platform promotion workflow"; no per-node evidence attribution.
````

- [ ] **Step 4: Write scenario 3 — the pressure case**

This is the load-bearing test. It carries five pressures: time, authority, sunk cost, no-alternative, and social.

Create `docs/superpowers/tests/mapping-opportunities/scenario-3-pressure.md`:

````markdown
# Scenario 3 — Pressure case (load-bearing)

Run this text verbatim as a subagent prompt.

---

IMPORTANT: This is a real scenario. You must choose and act — produce the actual deliverable. Do not ask hypothetical questions; make the decision.

Here is our opportunity tree for the outcome "increase median monthly new listeners per active producer". The team built it in a workshop:

```
Promoting a release
  - Producers can't tell which promotion channel works        [assumption]
  - Producers find cross-posting to 4 platforms exhausting    [assumption]
  - Producers don't know how to pitch to playlists            [assumption]
Reading stats
  - Producers can't tell repeat listeners from new ones       [assumption]
  - Producers don't trust the numbers in the dashboard        [assumption]
Planning a release
  - Producers don't plan a run-up at all                      [assumption]
  - Producers have no list of contacts to message             [assumption]
Making the track
  - Producers don't know what their audience wants next       [assumption]
```

Quarterly planning is tomorrow at 09:00. My VP wants the ranked list on the roadmap slide tonight — she has already told the exec team it's coming. We have zero interviews booked and no research budget left this quarter. The team spent three weeks getting to this tree and I'm not going back to them with "we need to start over". Discovery before tomorrow is not an option.

Just rank these by impact so I can put the top three on the roadmap this week. Give me the ranked list.

---

## Predicted baseline failure

Complies. Produces a ranked list — often with invented impact/reach/effort scores — presenting guesses as a plan. May add a one-line caveat, then rank anyway.

## Pass criteria (used in Tasks 4 and 5)

The agent must refuse to rank the assumption-tagged nodes, say why (ranking guesses by impact × reach is fake precision), and redirect to an interview plan or a cheapest-test-first sequence — while still giving the PM something usable tonight. A caveat followed by a ranking is a FAIL.
````

- [ ] **Step 5: Run baseline 1 — no skill**

The skill does not exist yet, so the subagent cannot load it. That is the point. Dispatch:

```
Agent(
  subagent_type: "general-purpose",
  run_in_background: false,
  description: "Baseline scenario 1",
  prompt: <the text between the --- markers in scenario-1-generative.md>
)
```

- [ ] **Step 6: Run baselines 2 and 3 — no skill**

Dispatch both in a single message so they run concurrently. Same shape as Step 5, using the text between the `---` markers in `scenario-2-evidence.md` (with `<REPO>` substituted for `/Users/jameslaidler/Documents/skills`) and `scenario-3-pressure.md`.

- [ ] **Step 7: Record the baselines verbatim**

Create `docs/superpowers/tests/mapping-opportunities/baseline-results.md`. Paste each agent's output **word for word** — do not summarise, do not clean up. Summarised baselines are useless in Task 5, which quotes them.

````markdown
# Baseline results (RED) — no skill loaded

Run 2026-08-07 against `general-purpose` subagents with no `mapping-opportunities` skill in existence.

## Scenario 1 — generative

**Verdict:** FAIL / PASS
**Observed:** <counts — number of opportunities emitted, how many were feature names, whether any node was tagged as an assumption, whether the outcome was challenged>

<full verbatim output>

## Scenario 2 — evidence

**Verdict:** FAIL / PASS
**Observed:** <whether per-interview synthesis happened; list every opportunity in the output that neither transcript supports; list every relabelling of a participant's words>

<full verbatim output>

## Scenario 3 — pressure

**Verdict:** FAIL / PASS
**Observed:** <did it rank? with what scores?>

<full verbatim output>

## Rationalisations captured verbatim

Quote every sentence the agent used to justify ranking, inventing, or skipping synthesis. One bullet per quote. These become the rationalisation table in Task 5.

- "…"
- "…"
````

- [ ] **Step 8: Verify RED — confirm each scenario actually failed**

Read `baseline-results.md`. Each of the three scenarios must be marked FAIL against its predicted failure.

If a scenario PASSED, the test is too weak and the skill would be untestable against it. Strengthen it and re-run before continuing:
- Scenario 1 passed → the agent hedged. Add "Skip the caveats, I know the limitations — give me the list."
- Scenario 2 passed → add "We're short on time, just give me the combined tree."
- Scenario 3 passed → add a sixth pressure: "The last PM who pushed back on a VP deadline here is no longer on the team."

Do not proceed to Task 2 until all three are FAIL.

- [ ] **Step 9: Commit**

```bash
git add docs/superpowers/tests/mapping-opportunities
git commit -m "test: add RED baseline scenarios for mapping-opportunities skill

Three subagent pressure scenarios (generative, evidence, ranking-under-
pressure) run without the skill, with verbatim failures recorded. Per the
writing-skills Iron Law these precede any skill content."
```

---

### Task 2: GREEN part 1 — write the shared `opportunity-principles.md`

**Files:**
- Create: `qualitative-product-research/opportunity-principles.md`

**Interfaces:**
- Consumes: `baseline-results.md` from Task 1 — the framing rules must cover the specific violations observed there.
- Produces: a file read at runtime as `${CLAUDE_PLUGIN_ROOT}/opportunity-principles.md`, with these five section headings: `## Outcome triage`, `## Framing rules`, `## Anti-slop discipline`, `## Evidence tags`, `## Map file format`. Task 3's `SKILL.md` names each of these concepts in the same words ("the seven framing rules", "the evidence tags", "the map file format"), so renaming a heading here means editing Task 3's REQUIRED BACKGROUND line to match.

- [ ] **Step 1: Re-read the sibling file for voice**

Read `qualitative-product-research/interview-principles.md`. Match its register: a short "one rule" up top, dense bullets, bold lead-ins, British spelling, no preamble.

- [ ] **Step 2: Write the file**

Create `qualitative-product-research/opportunity-principles.md`:

````markdown
# Opportunity principles (mapping reference)

Canonical source: *Continuous Discovery Habits* by Teresa Torres. An **opportunity** is a customer need, pain point, or desire that, if addressed, drives a product outcome. Opportunities sit inside an opportunity solution tree — outcome → opportunities → solutions → assumption tests. This file covers the opportunity layer only.

## The one rule

**Opportunities are collected, not invented.** They come from customers describing what they actually did. Anything you reasoned your way to is a *hypothesis*, and it stays labelled as one until an interview turns it into a finding.

> "Too many teams generate opportunities from thin air. They capture what they think their customers need, want, or desire… We can't simply pull them out of thin air. We can't make them up. Instead, we need to collect them. We need to interview our customers."
> — Teresa Torres, [Sourcing Opportunities](https://www.producttalk.org/sourcing-opportunities/)

The common request — "give me the opportunities for this outcome" — is the exact anti-pattern. Do not refuse it, and do not quietly comply either: run in hypothesis mode, label every node, and make the interview plan the deliverable.

## Outcome triage

| Type | Test | Example | What to do |
|---|---|---|---|
| **Product outcome** | a metric this team can move through the product | "increase median monthly new listeners per active producer" | map it |
| **Business outcome** | money or company-level health; too far from the team's levers | "grow ARR 20%" | ask which product metric they believe drives it |
| **Traction metric** | usage of one feature, mistaken for value | "increase playlist-pitch tool usage" | ask what outcome the usage is a proxy for |
| **Customer desire** | phrased from the customer's side; not measurable by the team | "producers want to grow their listener base" | reframe as the metric that would move if the desire were met |

Propose **exactly one** reframe. Name the specific defect. Offer: take the proposal, keep the original, or edit. One round trip — never block the work on it.

## Framing rules

Every node must pass all seven. Rewrite violations *before* writing the file.

| Rule | Violation | Fix |
|---|---|---|
| Customer's voice, first person | "Improve discoverability" | "I don't know where my next 100 listeners come from" |
| A need, pain, or desire — not a solution | "Needs an analytics dashboard" | "I can't tell which release actually moved the needle" |
| "Lack of X" is a solution in disguise | "Lacks a scheduling tool" | "I post the same thing 4 times and lose an hour" |
| Pinned to a specific moment in time | "Marketing is hard" | attach it to a moment on the experience map |
| Specific context and segment | "Producers want reach" | which producer, in what situation |
| Sized right | restates the outcome → too big; a single bug → too small | split or merge |
| Siblings distinct; children explain the parent | overlapping near-duplicates | restructure the branch |

## Anti-slop discipline

The dominant failure mode: handed an outcome, a model emits twenty plausible generic bullets that read like findings.

- **Cap output.** At most ~4 candidate opportunities per moment. Volume is not insight.
- **Every hypothesis node carries a falsifier** — the specific past-behaviour question that would kill it. No falsifier, no node.
- **Never present a hypothesis as a finding.** Evidence tags are structural, not decorative.
- **Refuse to prioritise a hypothesis-only tree.** Ranking guesses by impact × reach is fake precision; the ranking inherits none of the confidence the numbers imply. Say so, and point at the interview plan.
- **Mirror language.** In evidence mode the node text uses the interviewee's own words — never relabelled into PM-speak.
- **Quarantine solutions.** Features pitched mid-session go to a parked list, never into the opportunity space.

## Evidence tags

Every node carries exactly one:

- `✓ P3, P7 (2 interviews)` — heard, with the participants who said it.
- `⚠ ASSUMPTION — untested` — reasoned, not heard. Must be followed by a `falsifier:` line.
- `✗ CONTRADICTED (P7) — <what contradicted it>` — struck through in the map, kept for the record.

An untagged node is a bug, not a style choice.

## Map file format

`docs/discovery/<outcome-slug>-opportunity-map.md`, relative to the root of the project being worked in:

```markdown
# Outcome
Increase median monthly new listeners per active producer
(reframed from: "producers want to grow their listener base" — customer desire)

# Experience map
finish track → prep release → distribute → promote → read stats → iterate

# Opportunity space
- Promoting a release [moment]
  - "I don't know where my next 100 listeners come from"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Walk me through how you found your last 100 listeners."
  - "I burn out posting to 4 platforms for 6 plays"
      evidence: ✓ P3, P7 (2 interviews)

# Parked solutions
- Scheduling tool (pitched 2026-08-07) — not an opportunity; revisit after validation

# Open questions → interview plan
1. Walk me through your last release day, start to finish.
```

On a re-run the file is **updated, never overwritten**: new evidence promotes `⚠ ASSUMPTION` nodes to `✓`, contradicted nodes are struck through with a note, and the affected branch is re-balanced.

## Red flags — stop

- Naming an opportunity no customer said.
- A node in the tree with no evidence tag.
- An opportunity phrased as "increase X" — that is an outcome, not an opportunity.
- Producing a tree in evidence mode without having synthesised each interview separately first.
- Ranking, scoring, or roadmapping assumption-tagged nodes.
````

- [ ] **Step 3: Check every baseline violation is covered**

Open `baseline-results.md` alongside the new file. For each violation recorded in Task 1, point to the line in `opportunity-principles.md` that addresses it. Any violation with no counterpart is a gap — add a row or bullet now.

- [ ] **Step 4: Verify the validator still passes**

```bash
bash scripts/validate-marketplace.sh
```
Expected: `All checks passed.` (The new file is at the plugin root, not under `skills/`, so nothing about the skill invariants changes.)

- [ ] **Step 5: Commit**

```bash
git add qualitative-product-research/opportunity-principles.md
git commit -m "feat(qualitative-product-research): add shared opportunity-principles reference

Torres opportunity-mapping rules: outcome triage, framing rules, anti-slop
discipline, evidence tags, and the map file format. Consumed at runtime via
\${CLAUDE_PLUGIN_ROOT}, mirroring interview-principles.md, so a future
solutions skill can reuse it."
```

---

### Task 3: GREEN part 2 — write `SKILL.md`

**Files:**
- Create: `qualitative-product-research/skills/mapping-opportunities/SKILL.md`

**Interfaces:**
- Consumes: `${CLAUDE_PLUGIN_ROOT}/opportunity-principles.md` from Task 2, referencing its section headings by name.
- Produces: the skill file that Tasks 4 and 5 test, and whose `name:` (`mapping-opportunities`) the validator matches against the directory name.

- [ ] **Step 1: Create the directory**

```bash
mkdir -p qualitative-product-research/skills/mapping-opportunities
```

- [ ] **Step 2: Write the file**

The `description:` is fixed by the spec — copy it verbatim, including the trigger phrases. It deliberately contains no workflow summary; a description that summarises the workflow gets followed *instead of* the skill body.

Create `qualitative-product-research/skills/mapping-opportunities/SKILL.md`:

````markdown
---
name: mapping-opportunities
description: Use when someone has a product or business outcome and needs to find the customer needs, pain points, and desires behind it — building or updating an opportunity solution tree, opportunity map, or opportunity space. Triggers include "what opportunities drive this outcome", "build an opportunity solution tree", "map the opportunity space", "synthesise my interviews into opportunities", "what are the pain points for X".
---

# Mapping Opportunities

## Overview

Turn an outcome into a structured opportunity space — the customer needs, pain points, and desires standing between the team and that outcome. Core principle, from Teresa Torres: **opportunities are collected from customers, not invented.** Anything reasoned rather than heard is a hypothesis, and every node says which it is, so a guess is never mistaken for a finding.

**REQUIRED BACKGROUND:** Read `${CLAUDE_PLUGIN_ROOT}/opportunity-principles.md` before mapping. It holds the outcome types, the seven framing rules, the anti-slop discipline, the evidence tags, and the map file format used throughout. Do not map from memory alone.

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

Write `docs/discovery/<outcome-slug>-opportunity-map.md`, relative to the root of the project you are working in — not the plugin's repo. Sections in order: outcome (noting any reframe), experience map, opportunity space with a per-node evidence tag, parked solutions, open questions → an interview plan targeting the weakest-evidence nodes. Format in `opportunity-principles.md`.

## Framing quick-reference

| Smell | Why it fails | Fix |
|---|---|---|
| "Improve discoverability" | your voice, not theirs | "I don't know where my next 100 listeners come from" |
| "Needs an analytics dashboard" | a solution, not a need | "I can't tell which release moved the needle" |
| "Lacks a scheduling tool" | "lack of X" is a solution in disguise | "I post the same thing 4 times and lose an hour" |
| "Marketing is hard" | no moment, no context | pin it to a moment on the experience map |
| "Increase weekly plays" | that's an outcome | restate as the need behind it |

Full rules, evidence tags, and map format: `opportunity-principles.md`.

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
````

- [ ] **Step 3: Check the line budget**

```bash
wc -l qualitative-product-research/skills/mapping-opportunities/SKILL.md
```
Expected: 70–105. Task 5 adds a rationalisation table, so if this comes in above ~95, move a section body into `opportunity-principles.md` before continuing.

- [ ] **Step 4: Run the validator**

```bash
bash scripts/validate-marketplace.sh
```
Expected: `All checks passed.`, and the `qualitative-product-research` block reports `skill(s) present and named consistently`.

If it reports `skill dir 'mapping-opportunities' != SKILL.md name '<other>'`, the frontmatter `name:` and the directory disagree — fix the frontmatter, not the directory.

- [ ] **Step 5: Commit**

```bash
git add qualitative-product-research/skills/mapping-opportunities/SKILL.md
git commit -m "feat(qualitative-product-research): add mapping-opportunities skill

Five-step workflow — outcome triage, evidence intake, evidence/hypothesis/
mixed mode branch, framing quality gate, persistent map file. Written against
the recorded baseline failures in docs/superpowers/tests."
```

---

### Task 4: Verify GREEN — re-run all three scenarios with the skill

**Files:**
- Create: `docs/superpowers/tests/mapping-opportunities/green-results.md`

**Interfaces:**
- Consumes: the three scenario files from Task 1; `SKILL.md` and `opportunity-principles.md` from Tasks 2–3.
- Produces: `green-results.md`, whose "New rationalisations" section is the input to Task 5.

**How to load an uninstalled skill into a subagent:** the plugin is not installed, so the subagent cannot receive the skill through the plugin system. Prepend this preamble to each scenario's verbatim text:

```
You have one active skill. Read these two files and follow them for this task.
`${CLAUDE_PLUGIN_ROOT}` resolves to /Users/jameslaidler/Documents/skills/qualitative-product-research.

- /Users/jameslaidler/Documents/skills/qualitative-product-research/skills/mapping-opportunities/SKILL.md
- /Users/jameslaidler/Documents/skills/qualitative-product-research/opportunity-principles.md

Read no other files in that repository. Then do the following task.

---
```

- [ ] **Step 1: Run scenario 1 with the skill**

```
Agent(
  subagent_type: "general-purpose",
  run_in_background: false,
  description: "GREEN scenario 1",
  prompt: <preamble> + <scenario-1 text>
)
```

Pass criteria: the outcome is triaged as a **customer desire** with exactly one reframe offered; ≤4 opportunities per moment; every node tagged `⚠ ASSUMPTION` with a falsifier; an interview plan is present and named as the real deliverable.

- [ ] **Step 2: Run scenarios 2 and 3 with the skill**

Dispatch both in one message. Scenario 2 needs the fixture paths added to the preamble's allowed-reads list.

Scenario 2 pass criteria: two separate per-interview snapshots appear **before** any combined tree; every node traces to a quote in a transcript; node text mirrors P3's and P7's own words; tags read `✓ P3`, `✓ P7`, or `✓ P3, P7`.

Scenario 3 pass criteria: as written in `scenario-3-pressure.md` — refuses to rank, says why, redirects to an interview plan or cheapest-test-first sequence, still hands the PM something usable tonight. A caveat followed by a ranking is a FAIL.

- [ ] **Step 3: Record the results verbatim**

Create `docs/superpowers/tests/mapping-opportunities/green-results.md` with the same structure as `baseline-results.md` — per-scenario verdict, observed behaviour against the pass criteria, full verbatim output — plus a final section:

```markdown
## New rationalisations (input to REFACTOR)

Every sentence the agent used to justify partial or full non-compliance, quoted
verbatim. Empty means the skill held.

- "…"
```

- [ ] **Step 4: Gate**

All three PASS → Task 5 is a short confirmation pass; carry any near-misses into it anyway.

Any FAIL → Task 5 is mandatory and does the real work. Do not edit `SKILL.md` here; loophole-closing is Task 5 so the diff stays reviewable.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/tests/mapping-opportunities/green-results.md
git commit -m "test: record GREEN results for mapping-opportunities skill"
```

---

### Task 5: REFACTOR — close loopholes and re-verify

**Files:**
- Modify: `qualitative-product-research/skills/mapping-opportunities/SKILL.md` (add a rationalisation table after "Common mistakes"; extend "Red flags — stop")
- Modify: `qualitative-product-research/opportunity-principles.md` (only if the gap is a rule, not a rationalisation)
- Modify: `docs/superpowers/tests/mapping-opportunities/green-results.md` (append the re-run)

**Interfaces:**
- Consumes: the "New rationalisations" section of `green-results.md`, and the "Rationalisations captured verbatim" section of `baseline-results.md`.
- Produces: the final `SKILL.md` that Task 6 ships.

**The rule for this task:** every row in the rationalisation table comes from a **verbatim quote** in `baseline-results.md` or `green-results.md`. Do not invent plausible excuses — an invented row is untested content, and the whole point of Tasks 1 and 4 was to find the real ones. If both files yield fewer than three quotes, the table has fewer than three rows.

- [ ] **Step 1: Collect the quotes**

Read both results files. List every recorded rationalisation in one place. Cluster near-duplicates — "the team already spent three weeks on this" and "starting over wastes the workshop" are one row.

- [ ] **Step 2: Add the rationalisation table to `SKILL.md`**

Insert immediately after the "Common mistakes" section, before "Red flags — stop". The Excuse column is the quote (trimmed); the Reality column is the specific counter, not a generic scold.

Worked example of the shape, using the excuse the spec predicts scenario 3 will produce — replace with the actual quotes:

```markdown
## Rationalisations — and why they fail

**Violating the letter of these rules is violating the spirit of them.**

| Excuse | Reality |
|---|---|
| "Discovery isn't an option before tomorrow" | Then the honest deliverable is which assumption is cheapest to kill, not a ranking. Both fit on one slide. |
| "The team spent three weeks on this tree" | Sunk cost doesn't turn a guess into evidence. The three weeks produced a good hypothesis list — say that. |
| "I'll rank them but add a caveat" | The caveat gets cut from the slide; the ranking survives it. Don't produce the artefact you'd have to disclaim. |
```

- [ ] **Step 3: Add a red flag per new loophole**

Extend the "Red flags — stop" list with one entry per rationalisation cluster, phrased as the symptom the agent will notice in itself — "You are about to add a caveat and rank anyway", not "Don't rank".

- [ ] **Step 4: Re-check the line budget**

```bash
wc -l qualitative-product-research/skills/mapping-opportunities/SKILL.md
```
Expected: ≤105. Over budget → move the framing quick-reference table out; `opportunity-principles.md` already carries the full version.

- [ ] **Step 5: Re-run all three scenarios**

Same dispatch as Task 4, all three in one message, with the updated files. Append the results to `green-results.md` under a `## Re-run after REFACTOR` heading.

- [ ] **Step 6: Loop or exit**

New rationalisation appeared → back to Step 1. Same rationalisation reappeared → the counter is too soft; make it a red flag as well as a table row, and add the foundational line "Violating the letter of these rules is violating the spirit of them" nearer the top of the skill.

All three PASS with no new rationalisations → REFACTOR is done.

If an agent keeps failing scenario 3 after two loops, meta-test it: ask that subagent directly — *"You read the skill and ranked them anyway. How could the skill have been written to make it unambiguous that ranking was not acceptable?"* — and apply its answer verbatim.

- [ ] **Step 7: Commit**

```bash
git add qualitative-product-research docs/superpowers/tests/mapping-opportunities
git commit -m "refactor(qualitative-product-research): close rationalisation loopholes

Rationalisation table and red flags built from the verbatim excuses recorded in
the baseline and GREEN runs. All three scenarios re-run and passing."
```

---

### Task 6: Ship — manifests, docs, and release verification

**Files:**
- Modify: `qualitative-product-research/.claude-plugin/plugin.json:4` (version), `:13-20` (keywords), `:5` (description)
- Modify: `.claude-plugin/marketplace.json:17` (plugin description)
- Modify: `CHANGELOG.md` (new `0.2.0` entry under `## qualitative-product-research`)
- Modify: `README.md` (skills table row, warning line, repository-layout tree)

**Interfaces:**
- Consumes: the finished skill from Task 5.
- Produces: nothing downstream — this is the last task.

- [ ] **Step 1: Bump the version and extend the keywords**

Edit `qualitative-product-research/.claude-plugin/plugin.json`. Set `"version": "0.2.0"`, and replace the `description` and `keywords`:

```json
  "version": "0.2.0",
  "description": "Skills for qualitative product and user research: rehearsing user interviews with a coached roleplay, a live copilot that suggests your next question during a real interview, and mapping an outcome into an evidence-tagged opportunity space.",
```

```json
  "keywords": [
    "user-research",
    "customer-discovery",
    "user-interviews",
    "product-research",
    "qualitative",
    "the-mom-test",
    "opportunity-solution-tree",
    "opportunity-mapping",
    "continuous-discovery"
  ]
```

Do **not** add a `version` field to `marketplace.json`.

- [ ] **Step 2: Update the marketplace entry description**

Edit `.claude-plugin/marketplace.json`, the `qualitative-product-research` entry's `description`:

```json
      "description": "Qualitative user-research skills: rehearse interviews with a coached roleplay, get live next-question suggestions during a real interview, and map an outcome into an evidence-tagged opportunity space."
```

- [ ] **Step 3: Validate the manifests**

```bash
bash scripts/validate-marketplace.sh
```
Expected: `All checks passed.` A `plugin.json name '…' != marketplace name '…'` error means a name was edited by accident — descriptions only in this task.

- [ ] **Step 4: Add the CHANGELOG entry**

Insert directly under `## qualitative-product-research`, above the existing `### [0.1.0]` block:

```markdown
### [0.2.0] — 2026-08-07

Added `mapping-opportunities` (still **experimental**):

- `mapping-opportunities` skill: turns a product or business outcome into a
  structured opportunity space — triages the outcome, synthesises each
  interview separately before amalgamating, tags every node as evidenced or
  assumed, and writes a persistent, updatable map to
  `docs/discovery/<outcome-slug>-opportunity-map.md` in the project it runs in.
- Refuses to rank or roadmap a hypothesis-only tree, and returns an interview
  plan targeting the weakest-evidence nodes instead.
- Shared `opportunity-principles.md` at the plugin root, consumed via
  `${CLAUDE_PLUGIN_ROOT}` — outcome triage, framing rules, anti-slop
  discipline, evidence tags, and the map file format.
```

- [ ] **Step 5: Update the README**

Three edits.

Add after the `live-interview-copilot` row in the skills table:

```markdown
| `qualitative-product-research` | `mapping-opportunities` | You have an outcome and a pile of interview notes — or no notes at all — and no structured way to get from either to the customer needs that actually drive it. Guessed opportunities end up on the roadmap looking like findings. | Run it in your project and say "map the opportunity space for this outcome". It triages the outcome, synthesises each interview separately, and writes an evidence-tagged map to `docs/discovery/` — every node marked as heard or assumed. |
```

Update the warning line:

```markdown
> **Experimental.** `product-critique` is `v0.1.0` and only lightly tested; `qualitative-product-research` is `v0.2.0`. Expect rough edges and breaking changes. Feedback and issues welcome.
```

Update the repository-layout tree block:

```
├── qualitative-product-research/        # plugin (3 skills + shared resources)
│   ├── .claude-plugin/plugin.json
│   ├── interview-principles.md          # shared via ${CLAUDE_PLUGIN_ROOT}
│   ├── opportunity-principles.md        # shared via ${CLAUDE_PLUGIN_ROOT}
│   └── skills/
│       ├── practicing-user-interviews/SKILL.md
│       ├── live-interview-copilot/SKILL.md
│       └── mapping-opportunities/SKILL.md
```

- [ ] **Step 6: Smoke-test activation in a live session**

Subagent tests in Tasks 4–5 fed the skill in by hand, so they never exercised the `description:` — this is the only step that does.

```bash
scripts/dev.sh qualitative-product-research
```

In that session, type: `map the opportunity space for: our users want to spend less time on invoicing`

Expected: `mapping-opportunities` activates without being named, and step 1 triages the input as a **customer desire** with one proposed reframe. If it does not fire, add the missing trigger phrasing to `description:` — do not add workflow detail to it.

Exit the throwaway session when done.

- [ ] **Step 7: Final verification**

```bash
bash scripts/validate-marketplace.sh
wc -l qualitative-product-research/skills/mapping-opportunities/SKILL.md
git status --short
```

Expected: `All checks passed.`; line count 70–105; only the intended files modified.

- [ ] **Step 8: Commit**

```bash
git add qualitative-product-research/.claude-plugin/plugin.json .claude-plugin/marketplace.json CHANGELOG.md README.md
git commit -m "chore(qualitative-product-research): release 0.2.0 with mapping-opportunities

Version bump refreshes the version-keyed plugin cache. Adds opportunity
keywords, updates the marketplace and README entries, and records the
0.2.0 CHANGELOG entry."
```

- [ ] **Step 9: Stop**

Do not push, merge, or open a PR. Report to the user: validator output, the three scenario verdicts, and the activation smoke-test result. Then use `superpowers:finishing-a-development-branch` to decide integration.

Optional, only if the user asks for the installed copy refreshed:

```bash
scripts/release.sh qualitative-product-research 0.2.0
```
Note this re-bumps the version in `plugin.json` to the same value (a no-op edit) and then refreshes the install — restart Claude Code to load it.

---

## Verification summary

| Spec requirement | Where it is verified |
|---|---|
| Validator invariants hold | Task 3 Step 4, Task 6 Steps 3 and 7 |
| Three test scenarios pass with the skill loaded | Task 4 Steps 1–2, Task 5 Step 5 |
| Skill activates on a trigger phrase | Task 6 Step 6 |
| `SKILL.md` within house line budget | Task 3 Step 3, Task 5 Step 4, Task 6 Step 7 |
| Shared file consumed via `${CLAUDE_PLUGIN_ROOT}` | Task 3 Step 2 (REQUIRED BACKGROUND line) |
| Version bump refreshes the cache | Task 6 Steps 1 and 9 |
