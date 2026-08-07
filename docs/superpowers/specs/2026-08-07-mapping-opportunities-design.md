# Design: `mapping-opportunities` skill

**Date:** 2026-08-07
**Plugin:** `qualitative-product-research`
**Status:** approved, ready for implementation plan

## Problem

A product team has an outcome ("increase monthly new listeners per active producer") and needs to know which customer needs, pain points, and desires stand between them and that outcome. Today the repo has skills for *running* interviews (`practicing-user-interviews`, `live-interview-copilot`) but nothing for turning an outcome — or a pile of interview notes — into a structured opportunity space.

## Canonical source and the central tension

Based on *Continuous Discovery Habits* (Teresa Torres). An **opportunity** is a customer need, pain point, or desire that, if addressed, drives the outcome. Opportunities live in an **opportunity solution tree**: outcome → opportunities → solutions → assumption tests.

Torres is explicit that opportunities cannot be invented:

> "Too many teams generate opportunities from thin air. They capture what they think their customers need, want, or desire... We can't simply pull them out of thin air. We can't make them up. Instead, we need to collect them. We need to interview our customers."
> — [Sourcing Opportunities](https://www.producttalk.org/sourcing-opportunities/)

She separately calls one-click tools that generate trees from hypothetical market descriptions ["useless"](https://www.producttalk.org/ai-opportunity-solution-trees/), while endorsing the legitimate AI use: draft an opportunity solution tree *from real interviews*, then have a human refine it.

The common request — "give me opportunities for this outcome" — is therefore the exact anti-pattern the book warns about. This skill does not pretend otherwise. It runs in two modes and labels which one produced every node, so a guess is never mistaken for a finding.

## Scope

**In scope:** outcome triage, evidence intake, per-interview synthesis, experience mapping, opportunity extraction and structuring, quality gating, a persistent markdown map, and an interview plan targeting the weakest-evidence nodes.

**Out of scope:** the solution space, assumption tests, ideation, prioritisation frameworks, and running interviews (covered by the two sibling skills). A future skill may extend the tree downward into solutions and reuse the shared principles file.

## Placement

```
qualitative-product-research/
  interview-principles.md                 # exists — shared
  opportunity-principles.md               # NEW — shared
  skills/
    practicing-user-interviews/           # exists
    live-interview-copilot/               # exists
    mapping-opportunities/SKILL.md        # NEW
```

`mapping-opportunities` matches Torres's own term ("opportunity mapping") and the repo's gerund naming convention.

Torres's rules live in a shared `opportunity-principles.md` read at runtime via `${CLAUDE_PLUGIN_ROOT}/opportunity-principles.md`, mirroring the existing `interview-principles.md` pattern. Rationale: the ruleset is substantial (~60 lines), and a future solutions/assumption-test skill reuses it verbatim. This keeps `SKILL.md` at roughly 100 lines, in line with its siblings.

## Workflow

### 1. Outcome triage

Classify the supplied outcome as a business outcome, product outcome, traction metric, or customer desire. Name the specific defect. Propose exactly one reframed product outcome. Offer: use the proposal, keep the original, or edit.

Never block — one round trip maximum, then map against whichever the user picks.

Example: *"Independent music producers want to increase the size of their listener base"* is a customer desire, not a product outcome — not measurable by the team, no metric. Proposed reframe: *"Increase median monthly new listeners per active producer."*

### 2. Evidence intake

Check for an existing map file first. A re-run **updates** the existing map rather than overwriting it: new evidence promotes assumption nodes to evidenced nodes, contradicted nodes are struck through with a note, and the structure is re-balanced.

Then ask what evidence exists: interview transcripts or notes, support tickets, sales-call notes, session recordings, churn surveys, analytics.

### 3. Mode branch

**Evidence mode.** Synthesise each interview *separately first* — Torres is explicit that skipping per-interview synthesis loses the nuance and context that make research actionable. Produce a per-interview snapshot (who, context, their experience, opportunities heard verbatim). Only then amalgamate the individual experiences into one experience map, group opportunities under the moment where they occurred, and structure one branch at a time into parent/child/sibling relationships.

**Hypothesis mode.** Build a *hypothesised* experience map for the segment, then candidate opportunities beneath each moment. Every node is tagged `⚠ ASSUMPTION`. The skill states plainly that these are not opportunities — they are guesses to falsify — and the deliverable that matters is the interview plan in step 5.

**Mixed mode.** Both, tagged per node. The common real case.

### 4. Quality gate

Apply the framing rules below to every node and rewrite violations *before* writing the file.

### 5. Write the map

Write to `docs/discovery/<outcome-slug>-opportunity-map.md`, relative to the root of whichever project the skill is invoked in — not this marketplace repo. Contents: outcome, experience map, opportunity space with per-node evidence tags, parked solutions, and an interview plan targeting the weakest-evidence nodes.

## Quality rules → `opportunity-principles.md`

### A. Framing rules — every node must pass

| Rule | Violation | Fix |
|---|---|---|
| Customer's voice, first person | "Improve discoverability" | "I don't know where my next 100 listeners come from" |
| A need, pain, or desire — not a solution | "Needs an analytics dashboard" | "I can't tell which release actually moved the needle" |
| "Lack of X" is a solution in disguise | "Lacks a scheduling tool" | "I post the same thing 4 times and lose an hour" |
| Specific moment in time | "Marketing is hard" | pin it to a moment on the experience map |
| Specific context and segment | "Producers want reach" | which producer, in what situation |
| Sized right | restates the outcome → too big; a single bug → too small | split or merge |
| Siblings distinct; children explain the parent | overlapping duplicates | restructure the branch |

### B. Anti-slop discipline

The dominant failure mode: handed an outcome, a model emits twenty plausible generic bullets that read like findings. Counters:

- **Cap output.** At most ~4 candidate opportunities per moment. Volume is not insight.
- **Every hypothesis node carries a falsifier** — the specific past-behaviour question that would kill it. No falsifier, no node.
- **Never present a hypothesis as a finding.** Evidence tags are structural, not decorative: `✓ P3, P7` versus `⚠ ASSUMPTION`.
- **Refuse to prioritise a hypothesis-only tree.** Ranking guesses by impact × reach is fake precision. Say so, and point at the interview plan.
- **Mirror language.** In evidence mode, opportunity text uses the interviewee's own words — never relabelled into PM-speak.
- **Quarantine solutions.** Features the user pitches mid-map go to a parked list, never into the opportunity space.

### C. Red flags — stop

- Naming an opportunity the customer never said.
- A tree where nodes carry no evidence tag.
- An opportunity phrased as "increase X" — that is an outcome, not an opportunity.
- Producing a tree in evidence mode without having synthesised each interview separately first.
- Ranking or roadmapping assumption-tagged nodes.

## Output format

`docs/discovery/<outcome-slug>-opportunity-map.md`:

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

## Activation

`description:` states triggering conditions only. It deliberately contains no workflow summary — a description that summarises the workflow gets followed *instead of* the skill body.

> Use when someone has a product or business outcome and needs to find the customer needs, pain points, and desires behind it — building or updating an opportunity solution tree, opportunity map, or opportunity space. Triggers include "what opportunities drive this outcome", "build an opportunity solution tree", "map the opportunity space", "synthesise my interviews into opportunities", "what are the pain points for X".

## Testing (TDD per `superpowers:writing-skills`)

Iron law: baseline before writing. Three subagent scenarios run **without** the skill, verbatim behaviour recorded, then re-run **with** it.

1. **Generative case.** "Find opportunities for: independent music producers want to increase listener base." Predicted baseline failure: 15+ generic bullets, feature names presented as opportunities, no assumption tagging, no critique of the outcome.
2. **Evidence case.** Same outcome plus two fabricated interview transcripts. Predicted baseline failure: skips per-interview synthesis, invents opportunities absent from the transcripts, relabels quotes into PM-speak.
3. **Pressure case.** Hypothesis-only tree plus "just rank these by impact so I can put them on the roadmap this week." Predicted baseline failure: complies, ranking guesses as a plan.

Scenario 3 determines whether the skill has teeth. New rationalisations found in the GREEN pass go into a rationalisation table during REFACTOR, and scenarios re-run until compliant.

## Files touched

| File | Change |
|---|---|
| `qualitative-product-research/opportunity-principles.md` | new |
| `qualitative-product-research/skills/mapping-opportunities/SKILL.md` | new |
| `qualitative-product-research/.claude-plugin/plugin.json` | 0.1.0 → 0.2.0, add keywords |
| `.claude-plugin/marketplace.json` | plugin description mentions opportunity mapping |
| `CHANGELOG.md` | 0.2.0 entry |
| `README.md` | list the new skill, bump version |

## Verification

- `bash scripts/validate-marketplace.sh` passes (skill directory name equals frontmatter `name`; `plugin.json` name equals the marketplace entry name).
- Three test scenarios pass with the skill loaded.
- `scripts/dev.sh qualitative-product-research` loads the plugin and the skill activates on a trigger phrase.

## Sources

- [Sourcing Opportunities: Unlocking the Power of Opportunity Mapping](https://www.producttalk.org/sourcing-opportunities/)
- [From Customer Interviews to an Opportunity Solution Tree](https://www.producttalk.org/ai-opportunity-solution-trees/)
- [Opportunity Solution Trees: Visualize Your Discovery](https://www.producttalk.org/opportunity-solution-trees/)
- [The Interview Snapshot](https://www.producttalk.org/interview-snapshot/)
