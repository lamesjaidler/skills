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

Triage runs first, every time — before the experience map, before a single opportunity is written. An incoming outcome defaults to untriaged: mapping it as given, with no type recorded, is not a pass through this table, it's skipping the table.

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
- **Structure by moment, not by invented theme.** The experience map's moments are the only headings the opportunity space uses. A label you coined to summarise a pattern — "Discovery", "Momentum", "Attribution & Signal" — is analysis, not structure.
- **Every hypothesis node carries a falsifier** — the specific past-behaviour question that would kill it. No falsifier, no node.
- **Never present a hypothesis as a finding.** Evidence tags are structural, not decorative.
- **Refuse to prioritise a hypothesis-only tree — full stop, not "with a caveat."** Any ordering counts: a numeric impact × reach score, an ordinal 1–8 table against qualitative criteria, or an unranked "top three for the slide" — all borrow confidence the guesses don't have. Refusing means the interview plan or a cheapest-test-first sequence *replaces* the ranking, not a ranking with a caveat bolted on — a warning paragraph sitting next to a delivered order is still the failure. Relabelling the deliverable doesn't fix it either: calling the same ordered list "hypotheses" instead of "priorities" changes the label, not what was handed over.
- **Mirror language.** In evidence mode the node text *is* the interviewee's own words — verbatim, or a tight trim — not an analyst-authored headline with the real quote filed underneath as supporting evidence. A node that reads as a crisp infinitive phrase ("Trace a spike back to its cause") with the participant's actual sentence one line down in the evidence tag has been relabelled, even when the citation is correct. When several participants voice the same need, the node text is one of their actual sentences and the tag lists everyone who said a version of it.
- **Quarantine solutions.** Features pitched mid-session go to a parked list, never into the opportunity space.

## Evidence tags

Every opportunity node carries exactly one:

- `✓ P3, P7 (2 interviews)` — heard, with the participants who said it.
- `⚠ ASSUMPTION — untested` — reasoned, not heard. Must be followed by a `falsifier:` line.
- `✗ CONTRADICTED (P7) — <what contradicted it>` — struck through in the map, kept for the record.

An untagged opportunity node is a bug, not a style choice.

## Map file format

`docs/discovery/<outcome-slug>-opportunity-map.md`, relative to the root of the project being worked in:

```markdown
# Outcome
Increase median monthly new listeners per active producer
(reframed from: "producers want to grow their listener base" — customer desire)

# Experience map
finish track → prep release → distribute → promote → read stats → iterate

# Interviews
P3 — Mara, Lisbon, bedroom producer (lo-fi/downtempo), ~4 releases in 18 months
  experience: hand-posts every release to Instagram, two Discords, a subreddit, a WhatsApp group; can't tell which one moved a number
  opportunities heard: "I burned an evening and I think it got me six plays"; "It's all one number"

P7 — Dan, Leeds, part-time producer (house), releases roughly quarterly
  experience: hand-messages ~30 DJs one by one from a Notes-app list; can't tell which contact led to plays
  opportunities heard: "If I spend four of them messaging DJs that's four hours I didn't spend producing"; "I have no idea if that was him"

# Opportunity space
- Promote [moment]
  - "I don't know where my next 100 listeners come from"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Walk me through how you found your last 100 listeners."
  - "I burned an evening and I think it got me six plays"
      evidence: ✓ P3 (1 interview)
  - "If I spend four of them messaging DJs that's four hours I didn't spend producing"
      evidence: ✓ P7 (1 interview)

# Parked solutions
- Scheduling tool (pitched 2026-08-07) — not an opportunity; revisit after validation

# Open questions → interview plan
1. Walk me through your last release day, start to finish.
```

The interview-plan section is literal, askable questions, numbered, ready to use in the next call — never a paragraph recommending "more interviews" or "further validation" with no questions attached. If the next question can't be written out verbatim, the section isn't finished.

On a re-run the file is **updated, never overwritten**: new evidence promotes `⚠ ASSUMPTION` nodes to `✓`, contradicted nodes are struck through with a note, and the affected branch is re-balanced.

## Red flags — stop

- Naming an opportunity no customer said without tagging it ⚠ ASSUMPTION.
- An opportunity node in the tree with no evidence tag.
- An outcome sitting in the map with no type recorded from the triage table — silently accepted, not triaged.
- An opportunity phrased as "increase X" — that is an outcome, not an opportunity.
- Opportunities grouped under an invented theme heading ("Discovery", "Momentum", "Attribution & Signal") instead of a moment on the experience map.
- More than ~4 opportunities sitting under a single moment.
- Producing a tree in evidence mode without having synthesised each interview separately first.
- "Run more interviews" offered with no interview plan of actual, askable questions attached.
- Ranking, scoring, or roadmapping assumption-tagged nodes — ordinal or numeric, with or without a caveat attached.
