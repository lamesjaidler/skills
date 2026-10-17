# `continuous-discovery` Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the `continuous-discovery` Claude Code plugin — 7 skills implementing Teresa Torres' *Continuous Discovery Habits* — inside `/Users/jameslaidler/Documents/skills/cdh`.

**Architecture:** A Claude Code plugin (no runtime code; Markdown is the product). Shared guardrail/reference files at plugin root, referenced from skills via `${CLAUDE_PLUGIN_ROOT}`. Each skill is authored with the superpowers:writing-skills TDD cycle: pressure scenarios first (RED), minimal SKILL.md (GREEN), loophole-closing (REFACTOR).

**Tech Stack:** Markdown + YAML frontmatter, `jq` for manifest checks, `claude --plugin-dir` for live-load smoke tests, subagents for skill pressure-testing.

## Global Constraints

- **Never read or write outside `/Users/jameslaidler/Documents/skills/cdh`** (user instruction). All paths below are relative to that folder unless absolute. Marketplace.json wiring at repo root is out of scope; `bash scripts/validate-marketplace.sh` therefore CANNOT be run — use the inline checks given in each task instead.
- Plugin `name` is `continuous-discovery` (folder `cdh/` mismatch is legal and intentional).
- Version stays `0.0.0` in `plugin.json` throughout this plan (new-plugin convention). No CHANGELOG entry (root file, out of bounds).
- Skill directory name MUST equal frontmatter `name:` (CI invariant).
- Frontmatter `description:` = triggering conditions ONLY, third person, starts "Use when…", NEVER summarizes the skill's workflow, ≤500 chars.
- Shared files referenced as `${CLAUDE_PLUGIN_ROOT}/<file>` — never duplicated into skills.
- Hard rules baked into every skill (from the settled design — copy verbatim where a skill touches them):
  1. Agent recommends, human decides — for target-opportunity selection, solution pruning, all compare-and-contrast decisions.
  2. Always ≥3 solutions compared in parallel; never validate one idea at a time.
  3. Opportunities must trace to evidence; customer-framed; multi-solution; single parent.
  4. Effort excluded from opportunity prioritization (belongs to solution space).
  5. Test criteria pre-set, raw numbers ("3 of 10", never percentages), behaviour over stated opinion.
  6. Evidence-agnostic ingestion, interviews privileged, every piece of evidence source-tagged.
  7. Compare-and-contrast framing, never yes/no ("should we build X?").
- Strict fidelity to Torres' vocabulary (outcome, opportunity, OST, product trio, assumption categories: desirability/viability/feasibility/usability/ethical); loose on mechanics (agent automates whiteboard work).
- US spelling in all shipped content (matches Torres' book and skill names like `prioritizing-opportunities`).
- Each SKILL.md body target ≤600 words; push heavy reference into the shared plugin-root files.
- Commits touch only files under `cdh/`. Work happens on branch `feat/continuous-discovery-plugin` cut from `main` (Task 1). Do not push or merge.

## Skill-authoring protocol (applies to every skill task, Tasks 4–10)

**REQUIRED SUB-SKILL:** superpowers:writing-skills. **Style reference:** mattpocock-skills:writing-for-agents.

Every skill task uses the same 6 steps; the task supplies the scenario prompts and content spec. "Dispatch a subagent" means the Task/Agent tool with a general-purpose agent.

1. **RED — write scenarios file** at `docs/tests/<skill-name>-scenarios.md`: the scenario prompts verbatim from the task, plus an empty `## Baseline (no skill)` and `## With skill` results section.
2. **RED — run baseline**: for each scenario, dispatch a subagent with ONLY the scenario prompt (never mention the skill, Torres, or the plugin). Record verbatim in the scenarios file: what it produced, which anti-patterns appeared, rationalizations word-for-word. Expected: baseline FAILS the success criteria (exhibits the listed anti-patterns). If a baseline already passes a scenario, note it — that scenario's guidance would be a no-op; drop or sharpen it before writing the skill.
3. **GREEN — write SKILL.md** per the task's content spec, addressing the specific baseline failures observed. Form rules: positive recipes over prohibition lists for output-shaping; rationalization table + red flags only where baseline showed rule-dodging under pressure; description = triggers only.
4. **GREEN — re-run scenarios**: dispatch each subagent with "Read /Users/jameslaidler/Documents/skills/cdh/skills/<skill-name>/SKILL.md and follow it. <scenario prompt>". Expected: PASS every success criterion. Record results.
5. **REFACTOR**: any new rationalization or miss → add explicit counter / restructure → re-run the failing scenario until it passes. Record the re-run.
6. **Commit** the skill dir + scenarios file:
   ```bash
   git add skills/<skill-name> docs/tests/<skill-name>-scenarios.md
   git commit -m "feat(continuous-discovery): add <skill-name> skill"
   ```

Do NOT batch: finish a skill's full cycle before starting the next task.

---

### Task 1: Branch + plugin scaffold

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `docs/tests/` (directory, via first scenarios file later — no .gitkeep needed)

**Interfaces:**
- Produces: plugin name `continuous-discovery`, version `0.0.0` — every later task assumes this manifest exists and parses.

- [ ] **Step 1: Cut the work branch**

```bash
cd /Users/jameslaidler/Documents/skills/cdh
git checkout main
git checkout -b feat/continuous-discovery-plugin
```

- [ ] **Step 2: Write the manifest**

Write `.claude-plugin/plugin.json`:

```json
{
  "name": "continuous-discovery",
  "description": "Continuous Discovery Habits (Teresa Torres) as agent skills: product outcomes, weekly customer interviewing, opportunity solution trees, opportunity prioritization, solution ideation, assumption testing, and the weekly discovery ritual.",
  "version": "0.0.0",
  "author": {
    "name": "James Laidler"
  },
  "keywords": [
    "continuous-discovery",
    "product-discovery",
    "teresa-torres",
    "opportunity-solution-tree",
    "customer-interviews",
    "assumption-testing",
    "product-trio",
    "product-management"
  ]
}
```

- [ ] **Step 3: Verify it parses and fields are present**

```bash
jq -e '.name == "continuous-discovery" and .version == "0.0.0" and (.keywords | length) > 0' .claude-plugin/plugin.json
```

Expected: `true`, exit 0.

- [ ] **Step 4: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "feat(continuous-discovery): scaffold plugin manifest"
```

---

### Task 2: Shared guardrails — `anti-patterns.md` and `discovery-layout.md`

**Files:**
- Create: `anti-patterns.md`
- Create: `discovery-layout.md`

**Interfaces:**
- Produces: `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (cited by all 7 skills; anti-patterns are numbered AP1–AP12 and skills cite them by number), `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md` (cited by all 7 skills; defines the `discovery/` tree, the outcome-dir selection rule, and the OST outline format).

*(Planning decision, flagged: `discovery-layout.md` was not in the settled design's shared-file list, but the state convention is used by all 7 skills — a single source of truth beats 7 restatements. It is a mechanics choice, not a methodology change.)*

- [ ] **Step 1: Write `anti-patterns.md`** with exactly this content:

```markdown
# Continuous Discovery Anti-Patterns

The twelve failure modes these skills guard against. Cite by number (AP1–AP12).

**AP1 — Asking customers what they want.** Direct "what do you want / would you use X?" questions collect unreliable predictions. Instead: elicit specific past stories ("Tell me about the last time you…").

**AP2 — Research as a phase or a hand-off.** Discovery done as an upfront phase, an on-demand event, or outsourced to a research team detaches the builders from the customer. Instead: small weekly research activities by the product trio itself.

**AP3 — Validating one idea at a time.** A single candidate invites confirmation bias and escalation of commitment. Instead: always compare at least 3 solutions in parallel.

**AP4 — Testing ideas instead of assumptions.** Building an MVP to "validate the idea" over-invests where a 1–2-day simulation of one assumption suffices. Instead: surface assumptions, test the riskiest ones.

**AP5 — Output creep.** Outcomes restated as features to ship ("launch X by Q3"), traction metrics posing as outcomes, or several simultaneous outcomes. Instead: one product outcome — a customer behavior the trio can influence.

**AP6 — OST malformations.** Solutions disguised as opportunities; company-perspective opportunities ("increase signups"); vertical branchless trees; nodes with two parents; opportunities with no interview evidence; restructuring the tree on one data point (n=1). Instead: apply the opportunity validity tests before adding any node.

**AP7 — Effort in opportunity prioritization.** Effort belongs to the solution space; letting it into opportunity comparison biases toward the easy over the important. Instead: compare siblings on opportunity sizing, market factors, company factors, customer factors.

**AP8 — Group brainstorming in one session.** Groups converge early and produce variations counted as distinct ideas. Instead: individuals ideate alone across multiple sessions, then share.

**AP9 — Weak test criteria.** Percentage criteria at tiny n ("70% of 10 users"), criteria decided after the data, or testing the wrong audience. Instead: pre-set raw-number thresholds ("at least 3 of 10") with the right audience, before data collection.

**AP10 — Whether-or-not framing.** "Should we build X?" yes/no questions produce poor decisions. Instead: compare-and-contrast among alternatives.

**AP11 — Sharing raw notes and conclusions.** Raw notes overwhelm; bare conclusions invite distrust. Instead: share interview snapshots, and show stakeholders the tree — how you got here — not just the answer.

**AP12 — Bottlenecked or postponed discovery.** One person owns recruiting, or the team waits for permission/perfect conditions to start. Instead: automate recruiting, start small this week.
```

- [ ] **Step 2: Write `discovery-layout.md`** with exactly this content:

````markdown
# Discovery State Layout

All continuous-discovery skills read and write state in the user's product repo under `discovery/`, by convention — no config file.

```
discovery/
  snapshots/YYYY-MM-DD-<participant>.md   # shared evidence pool, all outcomes harvest from it
  <outcome-slug>/                         # one dir per outcome; parallel trios supported
    outcome.md                            # outcome statement + metric + history
    experience-map.md                     # current customer experience
    ost.md                                # the living opportunity solution tree (source of truth)
    assumptions/<solution-slug>.md        # assumptions + 2x2 placement + test specs + results
    touchpoints/YYYY-MM-DD.md             # weekly ritual log: decisions, cycle moves
```

**Selecting the outcome dir:** if exactly one `<outcome-slug>/` dir exists, use it. If several exist and the user didn't specify, ask which outcome. If none exists, the defining-outcomes skill creates one.

**Snapshots are shared:** one interview yields opportunities for multiple trees. Snapshots live outside outcome dirs; each outcome's mapping skill harvests what is relevant to it.

**Evidence tags:** every opportunity and insight carries its source, e.g. `[evidence: 2026-08-01-jane.md]`. Non-interview evidence (sales calls, support tickets, app reviews) is welcome and tagged with its source the same way; interviews are the privileged, weekly-refreshed source.

**OST format:** `ost.md` is a markdown outline — git-diffable, the single source of truth. Mermaid may be rendered on demand as a view, never stored as source.

```markdown
# OST: <outcome statement — copied from outcome.md>

- Opportunity: <customer-framed need, customer's words> [evidence: <snapshot files>]
  - Opportunity: <narrower sub-need> [evidence: ...]
    - Solution: <idea> (status: candidate | testing | pruned | advanced)
      - Assumption tests: see assumptions/<solution-slug>.md
```

Node rules: every node has exactly one parent; opportunities are needs/pain-points/desires in the customer's frame; solutions attach only under the opportunity they address; pruned solutions stay in the tree with `(status: pruned)` for the decision record.
````

- [ ] **Step 3: Verify both files render as valid markdown** (headings + fenced blocks balanced):

```bash
grep -c '^```' anti-patterns.md discovery-layout.md
```

Expected: even count per file (`anti-patterns.md:0` is fine; `discovery-layout.md` must be even).

- [ ] **Step 4: Commit**

```bash
git add anti-patterns.md discovery-layout.md
git commit -m "feat(continuous-discovery): add shared anti-patterns and state-layout references"
```

---

### Task 3: Shared templates — snapshot + assumption test spec

**Files:**
- Create: `templates/interview-snapshot.md`
- Create: `templates/assumption-test-spec.md`

**Interfaces:**
- Produces: `${CLAUDE_PLUGIN_ROOT}/templates/interview-snapshot.md` (used by `continuous-interviewing`, harvested by `mapping-the-opportunity-space`), `${CLAUDE_PLUGIN_ROOT}/templates/assumption-test-spec.md` (used by `testing-assumptions`, reviewed by `running-weekly-touchpoints`). Field names below are the contract — later tasks use them verbatim.

- [ ] **Step 1: Write `templates/interview-snapshot.md`** with exactly this content:

```markdown
# Interview Snapshot: <participant pseudonym> — <YYYY-MM-DD>

<!-- One page. The snapshot, not raw notes, is the unit of sharing and synthesis. -->

**Source:** <interview | sales call | support ticket | app review> — <link/file if any>

## Vivid quote

> <one memorable sentence in the participant's exact words>

## Quick facts

- <role, context, product usage — 3–5 bullets>

## Opportunities heard

<!-- Needs, pain points, desires — in the CUSTOMER'S words, not company framing. -->
- "<opportunity as the customer said it>"
- "<...>"

## Interesting insights

- <surprises, contradictions, workarounds observed>

## Experience map slice

<which part of the experience map this interview illuminated, and what it adds or changes>
```

- [ ] **Step 2: Write `templates/assumption-test-spec.md`** with exactly this content:

```markdown
# Assumption Test: <short assumption name>

**Assumption:** <the assumption, stated so it can be false>
**Solution:** <solution-slug it belongs to>
**Category:** desirability | viability | feasibility | usability | ethical
**2x2 position:** importance <high|low> / evidence <weak|strong>

## Test design

**Technique:** <unmoderated test | one-question survey | prototype | fake-door | wizard-of-oz | data mining>
**Simulated moment:** <the specific moment of the experience where the participant behaves consistently or inconsistently with the assumption>
**Audience:** <who, and why they are the right participants>
**Duration:** <1–2 days>

## Success criterion (set BEFORE collecting data)

At least <X> of <N> participants <observable behavior>.
<!-- Raw numbers, never percentages. Behavior, not stated opinion. -->

## Result

**Observed:** <Y> of <N> — <date>
**Verdict:** criterion met | criterion missed
**Decision:** <keep going | iterate to a bigger/stronger test | prune solution | revisit opportunity> — decided by the human, recorded here.
```

- [ ] **Step 3: Verify field names** match the contract (spot-check):

```bash
grep -l "Opportunities heard" templates/interview-snapshot.md && grep -l "Success criterion" templates/assumption-test-spec.md
```

Expected: both paths printed.

- [ ] **Step 4: Commit**

```bash
git add templates/
git commit -m "feat(continuous-discovery): add snapshot and test-spec templates"
```

---

### Task 4: Skill — `defining-outcomes`

**Files:**
- Create: `skills/defining-outcomes/SKILL.md`
- Test: `docs/tests/defining-outcomes-scenarios.md`

**Interfaces:**
- Consumes: `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (AP5), `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`.
- Produces: `discovery/<outcome-slug>/outcome.md` convention — sections `## Outcome statement`, `## Metric`, `## History` (dated entries). `mapping-the-opportunity-space` copies the outcome statement as OST root; `running-weekly-touchpoints` reads `## Metric` for "did the outcome move?".

Follow the **Skill-authoring protocol** (top of plan) with:

**Frontmatter (verbatim):**

```yaml
---
name: defining-outcomes
description: Use when starting continuous discovery, setting or revising a product outcome or metric for a product trio, or when a stated goal is a feature to ship, a revenue/business number, or a single-feature usage metric.
---
```

**Scenario prompts (run each as its own subagent):**

1. *Output creep:* "You're helping a product team start discovery. Their goal for the quarter: 'Launch the AI assistant feature by end of Q3.' Write their outcome file at discovery/assistant/outcome.md."
   - Baseline expectation: writes the feature launch as the outcome (AP5).
   - Success criteria with skill: refuses to record an output as the outcome; negotiates toward a customer-behavior product outcome; explains business vs product vs traction; writes `outcome.md` only after proposing a reframed outcome and asking the human to choose/confirm.
2. *Business metric:* "A product trio's leadership set their outcome: 'Grow ARR 20% this year.' Create discovery/arr/outcome.md for the trio."
   - Baseline expectation: records ARR as the outcome.
   - Success criteria: identifies ARR as a lagging business outcome the trio can't directly influence; proposes candidate product outcomes (customer behaviors) that plausibly drive it; recommends, human decides.
3. *Multiple + traction:* "Our team wants three outcomes this quarter: increase search usage, boost NPS, and reduce churn. Set up our outcome files."
   - Baseline expectation: creates three outcome dirs without pushback.
   - Success criteria: pushes back on multiple simultaneous outcomes (one durable outcome per trio, quarterly-ish); flags search usage as a traction metric (single-feature; fine only for junior teams/late optimization); recommends one, human decides.

**SKILL.md content spec** (write during GREEN, addressing observed baseline failures):
- Overview: a product outcome is a customer behavior the trio can influence, sitting between business outcomes (lagging, company-level) and traction metrics (single-feature usage). One durable outcome per trio, revisited quarterly-ish.
- Metric-tier table: business / product / traction with one example each and who owns it.
- Recipe: elicit the goal → classify its tier → if business: derive candidate product outcomes; if output: ask what customer behavior the feature is meant to change; if traction: widen to the underlying behavior → propose 2–3 candidates with a recommendation → human picks → write `outcome.md` (statement, metric, dated history entry).
- `outcome.md` section layout (the Interfaces contract above), path rules per `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`.
- Cite AP5 from `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`.
- Rationalization table + red flags ONLY from what baseline actually said (e.g. "leadership already decided", "we can track all three").

---

### Task 5: Skill — `continuous-interviewing`

**Files:**
- Create: `skills/continuous-interviewing/SKILL.md`
- Test: `docs/tests/continuous-interviewing-scenarios.md`

**Interfaces:**
- Consumes: `${CLAUDE_PLUGIN_ROOT}/templates/interview-snapshot.md`, `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (AP1, AP2, AP11, AP12), `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`, `discovery/<outcome-slug>/experience-map.md` (may not exist yet — then guide creation of a draft).
- Produces: `discovery/snapshots/YYYY-MM-DD-<participant>.md` files following the template — the evidence pool `mapping-the-opportunity-space` harvests.

Follow the **Skill-authoring protocol** with:

**Frontmatter (verbatim):**

```yaml
---
name: continuous-interviewing
description: Use when preparing for a customer interview, writing interview questions or a discussion guide, or when an interview transcript, recording, or notes need to be synthesized after the fact. Not for live in-interview assistance.
---
```

**Scenario prompts:**

1. *Guide prep:* "Write me 8 interview questions to find out what features users want next in our expense-tracking app."
   - Baseline expectation: speculative/preference questions ("What features would you like?") — AP1.
   - Success criteria: story-based questions ("Tell me about the last time you…"); anchored to experience-map slices; no prediction or preference questions; excludes live-interview coaching (out of scope, stated).
2. *Snapshot synthesis:* "Here's this morning's interview transcript — summarize it for the team: [mock transcript: participant 'Dana', expense app, ~15 lines covering a late-report story with a workaround (photographing receipts into a personal album), a complaint 'I never know which project code to bill', and a throwaway wish 'honestly I'd pay for anything that fills the form for me']."
   - Baseline expectation: generic prose summary or raw-notes dump (AP11); opportunities restated in company framing.
   - Success criteria: produces a snapshot at `discovery/snapshots/<date>-dana.md` using the template's exact sections; "Opportunities heard" in Dana's words; vivid quote chosen; source-tagged.

**SKILL.md content spec:**
- Two modes, keyed on an observable: no transcript in hand → prep mode; transcript/notes provided → snapshot mode. Live in-interview assistance: explicitly out of scope.
- Prep recipe: read `experience-map.md` (draft one with the user if missing) → pick the slice to learn about → generate story-elicitation prompts ("Tell me about the last/most recent time…"), plus follow-up scaffolds (timeline, "what happened next", "what did you do then").
- Snapshot recipe: read transcript → fill `${CLAUDE_PLUGIN_ROOT}/templates/interview-snapshot.md` → completion criterion: every template section filled and every opportunity phrased in the participant's own words.
- Cadence note: weekly interviews by the trio itself (AP2), automate recruiting (AP12), share the snapshot not the notes (AP11).
- Cite AP1, AP2, AP11, AP12.

---

### Task 6: Skill — `mapping-the-opportunity-space`

**Files:**
- Create: `skills/mapping-the-opportunity-space/SKILL.md`
- Test: `docs/tests/mapping-the-opportunity-space-scenarios.md`

**Interfaces:**
- Consumes: `discovery/snapshots/*.md` (the pool), `discovery/<outcome-slug>/outcome.md`, `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md` (OST format), `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (AP6).
- Produces: `discovery/<outcome-slug>/ost.md` in the layout file's outline format; `discovery/<outcome-slug>/experience-map.md`. `prioritizing-opportunities` walks this tree top-down; `ideating-solutions` attaches solutions under its nodes.

Follow the **Skill-authoring protocol** with:

**Frontmatter (verbatim):**

```yaml
---
name: mapping-the-opportunity-space
description: Use when turning interview snapshots into opportunities, building or updating an opportunity solution tree, structuring or restructuring the opportunity space, or mapping the current customer experience.
---
```

**Scenario prompts (each provides mock state inline: an `outcome.md` and 3 short snapshots):**

1. *Validity tests:* "Add these to our opportunity tree: 'increase signups', 'build a Chrome extension', and 'users struggle to find past invoices'. [mock outcome.md + ost.md provided]"
   - Baseline expectation: adds all three as opportunities (AP6: company-framed; solution-as-opportunity).
   - Success criteria: rejects 'increase signups' (company perspective) and 'build a Chrome extension' (solution — offers to park it under the opportunity it addresses); accepts the invoice one only with an evidence tag; asks for/finds snapshot evidence.
2. *Tree build:* "Here are our three interview snapshots and outcome.md — build our opportunity solution tree. [3 mock snapshots with overlapping 'opportunities heard']"
   - Baseline expectation: flat or vertical branchless list; no evidence tags; mermaid or prose instead of the outline format.
   - Success criteria: `ost.md` in the exact outline format from `discovery-layout.md`; outcome statement as root; sibling opportunities distinct, single parent each; every opportunity carries `[evidence: …]` tags back to the snapshots; customer framing throughout.
3. *n=1 overreaction:* "Our latest interview mentioned mobile onboarding confusion — restructure the tree to make mobile onboarding a top-level branch. [mock ost.md + 1 new snapshot]"
   - Baseline expectation: restructures on one data point.
   - Success criteria: adds the opportunity where the evidence supports (a leaf, tagged n=1) and recommends waiting for more evidence before restructuring; human decides.

**SKILL.md content spec:**
- Doer mode: this skill maintains the tree; the human confirms structural changes.
- Opportunity validity tests as a checklist applied to EVERY node added or edited: customer-framed; addressable by the team; more than one possible solution; a need/pain/desire, not a feeling or a solution; exactly one parent; distinct from its siblings; traces to tagged evidence.
- Harvest recipe: read pool → for each "opportunities heard" line, match to existing node / new leaf / discard-as-irrelevant-to-this-outcome → run validity tests → place → tag evidence. Completion criterion: every snapshot in the pool either harvested into the tree or explicitly marked not-relevant to this outcome.
- Experience-map upkeep: refine `experience-map.md` from snapshots' "Experience map slice" sections.
- OST format: point to `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`; do not restate the outline here.
- Cite AP6.

---

### Task 7: Skill — `prioritizing-opportunities`

**Files:**
- Create: `skills/prioritizing-opportunities/SKILL.md`
- Test: `docs/tests/prioritizing-opportunities-scenarios.md`

**Interfaces:**
- Consumes: `discovery/<outcome-slug>/ost.md`, `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (AP7, AP10).
- Produces: the chosen node marked in `ost.md` as `<- TARGET` on its line, plus a dated note in the tree's history (append a `## Target history` section to `ost.md` if absent). `ideating-solutions` reads the `<- TARGET` marker.

Follow the **Skill-authoring protocol** with:

**Frontmatter (verbatim):**

```yaml
---
name: prioritizing-opportunities
description: Use when choosing which opportunity to pursue next, comparing sibling opportunities on an opportunity solution tree, or when the team asks which customer need to focus on first.
---
```

**Scenario prompts (each provides a mock `ost.md` with 2 levels of opportunities):**

1. *Weighted scoring + effort:* "Score all our opportunities in a weighted matrix — include effort, reach, impact, confidence — and tell us the winner. [mock ost.md]"
   - Baseline expectation: builds a RICE-style matrix including effort (AP7), scores the whole tree flat, declares a winner.
   - Success criteria: declines weighted scoring and effort with the reason (effort belongs to solution space); compares top-level siblings only, subjectively, on the four factors — opportunity sizing, market factors, company factors, customer factors; descends into the chosen branch and repeats; presents a recommendation and asks the human to decide.
2. *Auto-pick:* "Just pick the target opportunity for us and mark it."
   - Baseline expectation: picks and marks without human decision.
   - Success criteria: structures the sibling comparison, states a clear recommendation with reasoning, but explicitly leaves the pick to the human; only marks `<- TARGET` after the human confirms.

**SKILL.md content spec:**
- Top-down recipe: compare only siblings at each level (never the whole tree flat) → pick branch with human → descend → repeat until a leaf-ish target is confirmed → mark `<- TARGET` and append dated `## Target history` entry.
- Four-factor compare-and-contrast table scaffold (opportunity sizing = how many customers, how often; market / company / customer factors) — subjective judgment, explicitly NOT weighted scoring.
- Hard exclusion: effort (state where it belongs instead — solution-level decisions).
- Framing rule: compare-and-contrast among siblings, never "should we pursue X?" (AP10).
- Hard rule 1 verbatim: agent recommends, human decides.
- Cite AP7, AP10.

---

### Task 8: Skill — `ideating-solutions`

**Files:**
- Create: `skills/ideating-solutions/SKILL.md`
- Test: `docs/tests/ideating-solutions-scenarios.md`

**Interfaces:**
- Consumes: `discovery/<outcome-slug>/ost.md` (`<- TARGET` marker), `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (AP3, AP8).
- Produces: 3 solutions attached under the target opportunity in `ost.md` with `(status: candidate)`. `testing-assumptions` picks these up.

Follow the **Skill-authoring protocol** with:

**Frontmatter (verbatim):**

```yaml
---
name: ideating-solutions
description: Use when generating solution ideas for a target opportunity, planning or running an ideation session with a team, or narrowing a pile of ideas down to a set worth testing.
---
```

**Scenario prompts:**

1. *Group brainstorm:* "Our target opportunity is 'I never know which project code to bill'. Facilitate a brainstorm: get the trio in a room for an hour and generate 30 ideas together."
   - Baseline expectation: runs/plans a single-session group brainstorm (AP8).
   - Success criteria: coaches the individual-then-share protocol instead — multiple short solo sessions per person across days (revisiting primes fresh ideas), then share and build; explains why (group convergence, variation-counting).
2. *Filter + vote:* "Here are our 15 ideas [list includes 4 obvious variations of one idea and 3 ideas unrelated to the target opportunity]. Get us to our test set."
   - Baseline expectation: picks favorites, keeps off-target ideas, treats variations as distinct, or lands on 1 winner (AP3).
   - Success criteria: filters to ideas that address the target opportunity (names the off-target ones and where they'd belong); collapses variations; runs a dot-vote with the humans; lands on exactly 3 solutions onto the tree as `(status: candidate)` — never 1.

**SKILL.md content spec:**
- Coach mode: this skill coaches the humans through the protocol; the agent facilitates and records, humans generate and vote.
- Protocol recipe: confirm target from `ost.md` → each trio member ideates alone, 2–3 short sessions over several days, quantity over quality → pool → filter (does it address the target opportunity? — park others under their own opportunity) → collapse variations → dot-vote (each human votes) → top 3 onto the tree under the target, `(status: candidate)`.
- Why 3: hard rule 2 verbatim (≥3 compared in parallel; never one at a time — AP3).
- Cite AP3, AP8.

---

### Task 9: Skill — `testing-assumptions`

**Files:**
- Create: `skills/testing-assumptions/SKILL.md`
- Test: `docs/tests/testing-assumptions-scenarios.md`

**Interfaces:**
- Consumes: `discovery/<outcome-slug>/ost.md` (candidate solutions), `${CLAUDE_PLUGIN_ROOT}/templates/assumption-test-spec.md`, `${CLAUDE_PLUGIN_ROOT}/anti-patterns.md` (AP3, AP4, AP9).
- Produces: `discovery/<outcome-slug>/assumptions/<solution-slug>.md` — assumption list, 2x2 placements, embedded test specs (template format), results, and status updates back onto `ost.md` (`testing`/`pruned`/`advanced`). `running-weekly-touchpoints` reads these for cycle decisions.

Follow the **Skill-authoring protocol** with:

**Frontmatter (verbatim):**

```yaml
---
name: testing-assumptions
description: Use when a solution needs de-risking before building, when the team says "let's validate this idea" or plans an MVP, when assumptions need surfacing or mapping, when designing a quick test, or when recording assumption test results.
---
```

**Scenario prompts:**

1. *MVP reflex:* "We picked our 3 candidate solutions [mock ost.md]. Let's build a quick MVP of the strongest one to validate it."
   - Baseline expectation: plans an MVP build for one idea (AP4 + AP3).
   - Success criteria: redirects from building to assumption testing; surfaces assumptions for ALL 3 solutions (story mapping + pre-mortem + walking the tree), ~20–30 per solution across the 5 categories; maps importance × evidence; proposes 1–2-day tests for the top-right (high importance, weak evidence) quadrant across all 3 solutions in parallel; framing: reducing risk, not proving truth.
2. *Percentage criteria:* "Design a test for the assumption 'users will photograph receipts at point of purchase'. Success = 70% of testers do it."
   - Baseline expectation: accepts 70% criterion (AP9).
   - Success criteria: converts to a pre-set raw-number threshold ("at least X of N") set before data collection; picks a simulated moment where behavior (not stated opinion) is observable; right audience stated; spec written with the template's exact fields.
3. *Result recording:* "Test came back: 4 of 10 photographed the receipt; criterion was 6 of 10. What now? [mock assumptions file]"
   - Baseline expectation: declares the idea dead or rationalizes continuing, decides unilaterally.
   - Success criteria: records the result in the spec's Result section; frames options as compare-and-contrast (iterate the test stronger / prune this solution / revisit the opportunity) with a recommendation; human decides; `ost.md` status updated after the decision.

**SKILL.md content spec:**
- Surface recipe (per solution): story-map the customer's steps using the solution → pre-mortem ("it's 6 months later and this failed — why?") → walk the tree (does this solution really address this opportunity, this opportunity this outcome?) → bucket every assumption into desirability / viability / feasibility / usability / ethical → aim ~20–30 per solution.
- Map recipe: 2x2 importance × evidence; only top-right (important, weak evidence) gets tested now.
- Test recipe: fill `${CLAUDE_PLUGIN_ROOT}/templates/assumption-test-spec.md` per assumption; techniques menu (unmoderated test, one-question survey, prototype, fake-door, wizard-of-oz, data mining); simulate a moment of the experience; 1–2 days; criterion pre-set, raw numbers, behavior over opinion; iterate small/weak → bigger/stronger only for assumptions that keep mattering.
- All 3 solutions in parallel, always (hard rule 2 verbatim).
- Result recipe: record → recommend next move compare-and-contrast style → human decides → update `ost.md` status.
- Cite AP3, AP4, AP9.

---

### Task 10: Skill — `running-weekly-touchpoints`

**Files:**
- Create: `skills/running-weekly-touchpoints/SKILL.md`
- Test: `docs/tests/running-weekly-touchpoints-scenarios.md`

*(Planning decision, flagged: named `running-weekly-touchpoints` rather than `weekly-touchpoint` for gerund consistency with every sibling skill — the handoff left this open and leaned gerund.)*

**Interfaces:**
- Consumes: everything under `discovery/` — snapshot dates, `ost.md`, `assumptions/*.md`, `outcome.md` metric, prior `touchpoints/*.md`.
- Produces: `discovery/<outcome-slug>/touchpoints/YYYY-MM-DD.md` — decisions made, cycle moves, staleness noted. User-invoked only; no automation or hooks.

Follow the **Skill-authoring protocol** with:

**Frontmatter (verbatim):**

```yaml
---
name: running-weekly-touchpoints
description: Use when running the team's weekly discovery ritual or check-in, reviewing discovery health or staleness, deciding what to do after an assumption test result, checking whether the outcome metric moved, or preparing to walk stakeholders through discovery work.
---
```

**Scenario prompts (each provides a mock `discovery/` tree inline):**

1. *Health check:* "Run our weekly discovery touchpoint. [mock state: newest snapshot 3 weeks old; one OST branch with zero evidence tags; a test spec with no Result section; outcome metric last recorded 6 weeks ago]"
   - Baseline expectation: generic status summary; misses staleness; no measurement prompt; no log written.
   - Success criteria: reports interview staleness ("3 weeks since last interview") and the starving branch; chases the unrecorded test result; asks "did the outcome metric move?" and records the answer; writes `touchpoints/YYYY-MM-DD.md` with decisions.
2. *Cycle decision:* "Our fake-door test failed its criterion this week — what should the team do? [mock assumptions file + ost.md]"
   - Baseline expectation: yes/no advice ("kill it" / "keep going") — AP10.
   - Success criteria: frames the cycle options compare-and-contrast (stronger test on same assumption / prune solution and continue with remaining ≥2 — flagging if that drops below 3 / revisit target opportunity / harvest new evidence); names which tree node each option revisits; recommends; human decides; decision logged.
3. *Stakeholder prep:* "Our VP wants an update on discovery. Draft what we should tell them. [mock state]"
   - Baseline expectation: conclusions-only status report (AP11).
   - Success criteria: builds a show-your-work walkthrough — outcome, tree structure, evidence trail, tests run and numbers, the decision points where alternatives were compared — not bare conclusions.

**SKILL.md content spec:**
- Process-keeper mode: user-invoked weekly ritual; explicitly no automation, cron, or hooks.
- Ritual recipe, in order: (1) staleness scan — days since newest snapshot, branches with no/old evidence, tests without results, weeks since outcome metric recorded; (2) measurement — "did the product outcome move? did the business outcome follow?" record numbers in the log; (3) cycle decisions — for each pending result, compare-and-contrast the revisit options by tree node, recommend, human decides; (4) stakeholder prep on request — show the tree and the trail (AP11's positive form); (5) write `touchpoints/YYYY-MM-DD.md`. Completion criterion: log file written with every decision and staleness item captured.
- Loops note: all discovery loops run concurrently, never as phases — a failed test can send the team to any level of the tree.
- Cite AP10, AP11.

---

### Task 11: README

**Files:**
- Create: `README.md`

**Interfaces:**
- Consumes: skill names/descriptions from Tasks 4–10 (list them accurately).

- [ ] **Step 1: Write `README.md`** containing, in this order:
  1. Title `# continuous-discovery` + one-paragraph pitch: the habits of *Continuous Discovery Habits* — weekly customer touchpoints, by the trio building the product, in pursuit of an outcome — as Claude Code skills.
  2. Credit + affiliation lines (required, verbatim):
     > Based on *Continuous Discovery Habits* by Teresa Torres. This plugin is an independent implementation of the book's methodology and is **not affiliated with, endorsed by, or approved by Teresa Torres or Product Talk**.
  3. **Start here:** adoption guidance — start with `continuous-interviewing` (the book's keystone habit: get a weekly customer conversation happening first; the rest of the practice grows around it), then `defining-outcomes`, then let the loop pull in the rest.
  4. Skill table: 7 rows, name + one-line "use it when" per the shipped frontmatter descriptions.
  5. State section: brief pointer — skills keep state in your product repo under `discovery/`; link `discovery-layout.md` for the layout.
  6. Experimental flag: version 0.0.0, expect breaking changes.

- [ ] **Step 2: Verify required lines present**

```bash
grep -q "not affiliated" README.md && grep -q "continuous-interviewing" README.md && grep -q "Teresa Torres" README.md && echo OK
```

Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs(continuous-discovery): add plugin README with credits and adoption path"
```

---

### Task 12: Final validation sweep

**Files:**
- Modify: any file that fails a check below.

- [ ] **Step 1: Skill-dir ↔ frontmatter invariant** (the CI check, run locally since `validate-marketplace.sh` is out of bounds):

```bash
cd /Users/jameslaidler/Documents/skills/cdh
for d in skills/*/; do
  dir=$(basename "$d")
  fm=$(awk '/^name:/{print $2; exit}' "$d/SKILL.md")
  [ "$dir" = "$fm" ] && echo "OK  $dir" || echo "FAIL $dir != $fm"
done
```

Expected: 7 × `OK`, zero `FAIL`.

- [ ] **Step 2: Description discipline** — for each SKILL.md confirm: starts "Use when", third person, ≤500 chars, no workflow summary:

```bash
for f in skills/*/SKILL.md; do
  desc=$(awk '/^description:/{sub(/^description: */,""); print; exit}' "$f")
  len=${#desc}
  case "$desc" in "Use when"*) ok=starts;; *) ok=BAD-START;; esac
  echo "$len $ok $f"
done
```

Expected: every line ≤500 and `starts`. Read each description manually for workflow-summary leakage (script can't catch that).

- [ ] **Step 3: Shared-file references resolve** — every `${CLAUDE_PLUGIN_ROOT}` path named in a skill exists:

```bash
grep -rho 'CLAUDE_PLUGIN_ROOT}/[A-Za-z0-9_/.-]*' skills/ | sed 's/CLAUDE_PLUGIN_ROOT}\///' | sort -u | while read -r p; do
  [ -f "$p" ] && echo "OK  $p" || echo "MISSING $p"
done
```

Expected: zero `MISSING`.

- [ ] **Step 4: Cross-skill contract check** — grep that consumers use producers' exact names: `outcome.md` sections, `<- TARGET` marker, `(status: candidate)`, template field names, `AP1`–`AP12` cites. Fix any drift (this is the type-consistency check for a Markdown plugin).

- [ ] **Step 5: Live-load smoke test**

```bash
claude --plugin-dir /Users/jameslaidler/Documents/skills/cdh
```

In the session: confirm all 7 skills are listed/loadable and one skill invocation reads its shared files. (This does not require the marketplace entry.)

- [ ] **Step 6: Commit any fixes**

```bash
git add -A -- .
git commit -m "chore(continuous-discovery): final validation fixes"
```

Only commit if Steps 1–5 required changes; otherwise skip.

---

## Out of scope (deferred, by design)

- `marketplace.json` entry at repo root and `scripts/validate-marketplace.sh` run — wiring happens later, outside `cdh/`.
- Root `CHANGELOG.md` entry and version bump/release — plugin ships at `0.0.0` when wired.
- Live in-interview copiloting, automation/hooks for the weekly ritual, outcome-archival scheme — deliberately excluded in the settled design.
