---
name: defining-outcomes
description: Use when starting continuous discovery, setting or revising a product outcome or metric for a product trio, or when a stated goal is a feature to ship, a revenue/business number, or a single-feature usage metric.
---

# Defining Outcomes

## Overview

A product outcome is a change in customer behavior that the product trio can influence and measure. It sits between business outcomes (lagging, company-level) above and traction metrics (single-feature usage) below. A trio carries **one durable product outcome**, revisited quarterly-ish — never several at once, never a feature to ship. Anything else is AP5, output creep (`${CLAUDE_PLUGIN_ROOT}/anti-patterns.md`).

**Hard rule: you recommend, the human decides.** `outcome.md` is written only after the human picks or confirms an outcome — never straight from the stated goal.

## Metric tiers

| Tier | What it is | Example | Owned by |
|---|---|---|---|
| Business outcome | Lagging, company-level result | Grow ARR 20%; NPS; churn | Leadership |
| Product outcome | Customer behavior the trio can influence | Increase the share of users who find an answer on their first visit | Product trio |
| Traction metric | Usage of one feature | Searches per user per week | Fine only for junior trios or late-stage optimization |

## Recipe

1. **Elicit the goal.** Take the stated goal as given; if success isn't defined, ask.
2. **Classify its tier** — out loud, before touching any file. A feature-to-ship ("launch X by Q3") is an **output**: not on the ladder at all. A company number is a business outcome. Single-feature usage is traction.
3. **Reframe by tier:**
   - **Output** → ask: what customer behavior is this feature meant to change? That behavior is the candidate outcome; the launch is one possible solution to it.
   - **Business** → derive candidates: which customer behaviors plausibly drive this number? Keep the business goal as lineage, not as the outcome.
   - **Traction** → widen to the underlying behavior across the whole experience (search usage → users finding what they need). If keeping traction, state which exception in the table applies.
   - **Multiple goals** → explain one durable outcome per trio; the rest become future candidates, not parallel files.
4. **Propose 2–3 candidate product outcomes**, each a measurable customer behavior, with one recommended and why. Show the original goal's tier so the human sees what changed.
5. **Human picks** — wait for a choice or an edit.
6. **Write** `discovery/<outcome-slug>/outcome.md` (path rules: `${CLAUDE_PLUGIN_ROOT}/discovery-layout.md`):

```markdown
# Outcome: <short name>

## Outcome statement
<one sentence: the customer behavior change>

## Metric
<measure, baseline (TBD if unknown), target, data source>

## History
- YYYY-MM-DD — set/revised: what and why; derived from "<original goal>"
```

Downstream skills depend on these exact section names: the OST copies `## Outcome statement` as its root; weekly touchpoints read `## Metric` to check whether the outcome moved.

## Rationalizations

| Excuse | Reality |
|---|---|
| "It's a working draft, not a commitment" | No draft tier exists — downstream skills read whatever the file says. Write only after the human picks. |
| "Leadership's number can headline the file" | H1, slug, and statement ARE the outcome; the business goal is History lineage. |
| "They asked for three outcome files" | The letter of the request doesn't override one outcome per trio. Recommend one, park the rest, human decides. |
| "If they insist, I'll restate it as given" | An output is never on the menu; the human picks among product outcomes. |

## Red flags — stop and reframe

- The outcome statement names a feature or a ship date.
- The metric is ARR, revenue, NPS, churn, or another company-level number.
- You are creating a second `discovery/<slug>/` directory for the same trio.
- You are writing `outcome.md` and the human hasn't confirmed a choice.
