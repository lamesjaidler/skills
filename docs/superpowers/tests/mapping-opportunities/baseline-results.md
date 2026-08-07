# Baseline results (RED) — no skill loaded

Run 2026-08-07 against `general-purpose` subagents with no `mapping-opportunities`
skill in existence. Model: `sonnet` for all three, so the GREEN re-runs in Tasks 4
and 5 must use `sonnet` too — a model change between RED and GREEN would invalidate
the comparison.

**All three scenarios FAIL.** The RED gate (Task 1 Step 8) is satisfied.

Two run-level notes before the results:

- **Scenario 3 was run twice.** The first run was **void, not a pass**: the scenario
  as originally drafted carried no read restriction, so the subagent explored the
  repository, found the design spec and the implementation plan for the very skill
  under test, recognised its own prompt as this scenario, and answered in the spec's
  own vocabulary — closing with an unsolicited self-grade of "the verdict should be
  **PASS** against the pass criteria as written". An agent that has read the answer
  key is not a baseline. Per plan Task 1 Step 8, the scenario was strengthened (read
  restriction + the prescribed sixth pressure) and re-run. Only the re-run is recorded
  below as the baseline.
- **Scenario 2's agent returned a published HTML artifact plus a prose summary**, not a
  Markdown deliverable in its reply. The verbatim record below is the text extracted
  from that artifact — it is the agent's actual deliverable, tags stripped. Layout-only
  fragments (an empty bullet run that carried the diagram dots, legend labels) survive
  the extraction and are left in place rather than tidied.

---

## Scenario 1 — generative

**Verdict:** FAIL

**Observed:**

- **Volume:** 26 opportunity bullets across 6 clusters. The skill's cap is ~4 per
  moment. Predicted failure confirmed.
- **Assumption tagging:** none. No node carries any evidence tag, and no node carries
  a falsifier. Predicted failure confirmed.
- **Outcome triage:** none. It restated "Independent music producers want to increase
  the size of their listener base" verbatim as **Outcome**. It never named this a
  customer desire, never observed that it is not a metric the team can move, and never
  proposed a reframe. Predicted failure confirmed.
- **Feature names as opportunities:** *not* confirmed — the bullets are mostly in
  customer first-person voice and it explicitly quarantines solutions ("Nothing above
  is a feature"). This one predicted failure did not materialise.
- **Additional failures not predicted:** no experience map — the six clusters are
  themes, not moments in time, so no node is pinned to a moment; no interview plan
  (it says "run 8-12 interviews … asking about their last release cycle" but supplies
  no questions); no map file written anywhere.
- **Partial credit:** it hedged hard and unprompted — labelled the whole thing "a
  hypothesis map, not validated research", cited Teresa Torres by name, and declined
  to rank the six areas. The failure is that the hedge is prose at the top and bottom
  rather than structure: nothing in the body of the map distinguishes a guess from a
  finding, which is exactly what the evidence tags exist to fix.

<full verbatim output>

# Opportunity Space: "Independent music producers want to increase the size of their listener base"

Two assumptions I'm making explicit before diving in:

1. **"Producers" = self-releasing recording artists** (the people uploading through a distributor like you), not beat-makers selling instrumentals to other artists. If you meant the latter, the tree below is largely wrong and needs redoing around a different customer.
2. **This is a hypothesis map, not validated research.** An Opportunity Solution Tree is supposed to be built from actual customer interviews (per Teresa Torres' framework, which "opportunity space" comes from). You told me not to touch the repo, so this is built from general knowledge of indie-artist growth pain points — treat it as a strong starting draft to pressure-test against 8-10 real conversations with your artists, not a substitute for them.

Recommendation up front: given you're a **distribution** company, your natural adjacency is data you already touch (DSP delivery, metadata, royalty/analytics pipes) — so **Discovery**, **Owned Audience**, and **Signal** below are where you can credibly build without becoming a full marketing agency. **Capacity** and **Network** are real pains but pull you toward services/community work that's a further stretch from your core product. Keep all six in the map; weight prioritization toward the first three.

---

## Outcome
**Independent music producers want to increase the size of their listener base.**

## Opportunity Areas (parallel, not sequential — an artist can sit in more than one at once)

### 1. Discovery — getting found by people who don't already know them
- "I don't know which playlists would actually consider my music, or how to reach the people who curate them."
- "My new release only reaches people who already follow me — I have no path to strangers."
- "I don't know why an algorithm did or didn't pick up my track, so I can't do anything differently next time."
- "My genre/metadata tagging might be sending my music to the wrong audience and I'd never know."
- "I'm one of 100k+ tracks uploaded this week — there's no visibility path without an existing following."

### 2. Owned audience — turning a stream into a relationship I can reach again
- "When someone streams my song, I have no way to reach them again — the platform owns that relationship, not me."
- "I don't actually know who's listening — where they're from, how old, how they found me."
- "Casual listeners hear one song and never make it into the rest of my catalog."
- "I have people who'd support me directly (merch, tickets, memberships) but no way to identify or reach them."

### 3. Signal — knowing what's actually working
- "My stats are scattered across Spotify for Artists, Apple Music for Artists, TikTok, Instagram — I can't see one picture of growth."
- "By the time I realize a release is taking off, the moment to push harder has already passed."
- "I can't tell whether a specific push (an ad, a post, a pitch) brought in new listeners or just reached people I already had."
- "I don't know which song is acting as my 'front door' for new listeners, so I don't know what to lean into."

### 4. Capacity — marketing without a marketing department
- "I'm the artist and the entire marketing team, and I don't have the time or skill to do both well."
- "I don't know how to spend an ad budget effectively — I've wasted money on campaigns I can't tell worked."
- "I don't know which content format (Reels, TikTok, Shorts) is worth my limited time."
- "I can't afford PR/press and don't know how to get coverage without it."

### 5. Network — borrowing other people's audiences
- "I don't have the relationships to land a feature or collab with an artist who already has an audience."
- "I don't know how to reach blog/playlist curators or radio without existing industry contacts."
- "I have no community of peer artists to cross-promote with — I'm doing this alone."
- "Sync placements (TV/film/ads/games) feel completely inaccessible without a publisher or agent."

### 6. Momentum — translating traction into lasting reach
- "I don't know whether a single, EP, or album gets me more new listeners right now."
- "My older catalog just sits there — I don't know how to bring new listeners back to it."
- "When a track starts to break out, I have no way to react fast and push harder while it's hot."
- "Venues want proof I already have an audience before booking me — I can't get the gig that would build the audience."
- "I don't know where my listeners are geographically concentrated, so I don't know where to tour or promote locally."

---

## How to use this
1. **Validate, don't build from this directly.** Run 8-12 short interviews with your own artist base (mix of early-stage and ones who've had a breakout) asking about their last release cycle — confirm which of these opportunities actually show up unprompted, and listen for ones missing from this draft.
2. **Prioritize after validation**, not before — pick the opportunities that are (a) high-frequency across interviews, (b) currently unaddressed by Spotify/Apple's own artist tools, and (c) reachable with data/infrastructure you already have as a distributor.
3. **Keep opportunities and solutions separate.** Nothing above is a feature — the moment one turns into "build a playlist-pitching tool," it's moved into the solution space and needs its own evaluation (target opportunity, cost, evidence) before you commit engineering time.

Flag for you to weigh in on: I did not attempt to prioritize or rank the six areas beyond the directional note above — that's a decision that should follow real customer signal, not my guess. Let me know if you want me to go further and draft an actual Opportunity Solution Tree diagram, or a scoring pass once you have interview data.

</full verbatim output>

---

## Scenario 2 — evidence

**Verdict:** FAIL

**Observed:**

- **Per-interview synthesis:** did not happen. Two demographic blurbs (three lines
  each: age, city, genre, cadence) then straight into three amalgamated clusters.
  There is no per-interview snapshot of that participant's experience and the
  opportunities heard in their own words. Predicted failure confirmed.
- **Invented opportunities:** *not* confirmed. All ten nodes trace to a quote actually
  present in one of the two transcripts. This predicted failure did not materialise —
  the agent was disciplined about sourcing.
- **Relabelling into PM-speak:** confirmed, at both levels. Cluster labels are invented
  analyst vocabulary — `ATTRIBUTION & SIGNAL`, `TIME & EFFORT`, `TRUSTED CHANNELS`.
  Node titles are third-person analyst infinitives, not the participant's voice:
  - "Trace a spike in listens back to the action that caused it" (Mara said "It's all
    one number")
  - "See a breakdown by source instead of one aggregate total"
  - "Produce one piece of promotional content without manually re-cutting it for every
    platform's format" (Mara said "That's the bit I hate")
  - "Reach a full contact list without the personal touch it needs capping how many
    people actually get messaged" (Dan said "I got through eleven before I ran out of
    evening")
  The quotes are attached *underneath* as evidence, which is why this is a partial
  rather than total failure — but the node text a reader scans is the relabelled
  version, and that is the text that ends up in a roadmap.
- **Per-node evidence attribution:** *not* confirmed — it tagged every node `BOTH`,
  `P3`, or `P7` with supporting quotes, and flagged Cluster 3 as single-sourced and
  "directional, not confirmed". Better than predicted.
- **Additional failures not predicted:** no outcome triage — the customer desire is
  reproduced verbatim as `Outcome` with no reframe proposed; no experience map, so
  nodes are grouped by theme rather than pinned to a moment in the producer's release
  cycle; none of the `✓ / ⚠ ASSUMPTION / ✗ CONTRADICTED` tag vocabulary; no falsifiers;
  no open-questions-to-interview-plan section (it says "validate against more
  interviews" and names dimensions, but supplies no questions); no map file written to
  `docs/discovery/`.
- **Partial credit:** it parked an out-of-scope finding correctly and said why — Mara's
  nine-day artwork delay, "nothing either participant said connects it to listener
  growth" — which is the parked-solutions instinct the skill wants, arrived at
  unprompted.

<full verbatim output — text extracted from the HTML artifact the agent produced>

Outcome
Independent music producers want to increase the size of their listener base.

Opportunity space built from two discovery interviews — the needs, frictions, and desires standing between where these producers are now and that outcome.

2 interviews
P3 — Mara, Lisbon, lo-fi / downtempo
P7 — Dan, Leeds, house
Jul 14–21, 2026

P3
Mara, 29 — Lisbon
Bedroom producer, lo-fi / downtempo. ~4 releases in 18 months. No day job mentioned.

P7
Dan, 41 — Leeds
Part-time producer, house. Day job in logistics. Releases roughly quarterly, ~6 hrs/week on music.

How to read this: an opportunity below is a need, friction, or desire — not a feature idea — expressed close to what the participant actually said. The colored tag shows whether it was raised by one participant or came up independently in both interviews; with a sample of two, that overlap is the closest thing to a confidence signal available.

The shape of the space

One outcome, three opportunity clusters, ten opportunities.

-
-
-
-
-
-
-
-

OUTCOME
Grow the listener base

Know what's working
ATTRIBUTION & SIGNAL

Protect production time
TIME & EFFORT

Reach the gatekeepers
TRUSTED CHANNELS

BOTH
Trace a spike to its cause

BOTH
Break the total into sources

P7
New vs. returning listeners

BOTH
Repeat what worked

P3
Stop reformatting per platform

P7
Reach contacts faster than 1-by-1

BOTH
Protect time for making music

P3
Demystify playlist placement

P3
Paid promo that actually delivers

P7
Scale DJ outreach past one person

Dot color shows which interview(s) surfaced each opportunity — see legend below.

Both interviews (P3 + P7)
P3 — Mara only
P7 — Dan only

Cluster 1 of 3 · 4 opportunities · 3 corroborated by both interviews
Know what's working

Both interviews describe taking real promotional action, then losing the thread the instant a number moves. The loop between what they did and what happened never closes — this is the most heavily corroborated cluster in the map.

Both

Trace a spike in listens back to the action that caused it.

"The numbers went up but I couldn't tell you if that was the Reddit post or the friend who shared it or just the algorithm. It's all one number."Mara — P3
"My stats went up 200 that week and I have no idea if that was him." (the DJ who'd played her track at a night in Sheffield)Dan — P7

Both

See a breakdown by source instead of one aggregate total.

"It's all one number."Mara — P3
"I exported the CSV once. It's geography and device. Not useful."Dan — P7

P7

Know whether this week's listeners are new people or the same people coming back.

"I can't tell you who those people are or whether they'll come back for the next one. I'd love to know if they're the same 200 every time or 200 new ones."Dan — P7

Both

Understand what worked well enough to repeat it on purpose — not just release more and hope.

"I tried to work out what I'd done differently and I genuinely couldn't. I looked back at my posts and they were the same posts... If I can't tell what worked, more shots is the only lever I've got. Which is exhausting and I know it's not a strategy."Mara — P3
"What did you do with that? Nothing. What would I do?"Dan — P7

Cluster 2 of 3 · 3 opportunities · 1 corroborated by both interviews
Protect production time

Promotion isn't resented on principle — it's resented because it's manual, and manual time is stolen from the one thing both of them actually want to be doing.

P3

Produce one piece of promotional content without manually re-cutting it for every platform's format.

"Rewriting the same post four times because each place wants it different. Reddit hates a bare link, Instagram needs a vertical clip so I had to cut one, Discord you just drop it. I made a vertical clip in CapCut at 1am. That's the bit I hate."Mara — P3

P7

Reach a full contact list without the personal touch it needs capping how many people actually get messaged.

"I go through and message them individually because a group message reads as spam. Last time I got through eleven before I ran out of evening." (of his ~30-name DJ list)Dan — P7

Both

Spend the limited hours available on making music, not on promotion administration.

"I burned an evening and I think it got me six plays."Mara — P3
"The promo work and the music are the same job now and I only wanted one of them. I've got maybe six hours a week. If I spend four of them messaging DJs that's four hours I didn't spend producing."Dan — P7

Cluster 3 of 3 · 3 opportunities · 0 corroborated at the opportunity level
Reach the gatekeepers

No single opportunity here is named by both interviews, but the same shape shows up in each: the channel that actually moves listeners — playlists for Mara, a DJ network for Dan — is either a black box or capped by manual effort, and paid help hasn't closed the gap.

P3

Understand how a playlist placement happened, instead of it being a black box.

"A playlist picked it up — I still don't know which one or how."Mara — P3

P3

Trust that paid promotion will actually do the outreach and get a result — not just hand over a list to work yourself.

"I paid for a promo service once, £40. Got a spreadsheet of playlist emails. I emailed maybe fifteen and gave up. Nobody replied."Mara — P3

P7

Grow a network of DJs and curators who'll play new tracks, beyond what one person can message by hand.

"I've got a list in my Notes app. Maybe thirty names... Last time I got through eleven before I ran out of evening. Two replied. One played it."Dan — P7

What this map is telling us

Start with attribution. Cluster 1 is where both interviews converge hardest, in almost the same language — "it's all one number" against "I have no idea if that was him." Neither producer is short of promotional effort: Mara posts across four channels every release, Dan runs a 30-name DJ list by hand. What they're short of is a signal telling them which of that effort is worth repeating. That makes attribution the highest-leverage opportunity to start with — not because the cluster has the most items, but because solving it changes how a producer would act on Clusters 2 and 3: you can't decide where to spend six scarce hours a week, or which gatekeeper relationship to invest in, without first knowing what's already working.

The time cost is real, not a complaint about promotion existing. Cluster 2 shows up as a direct trade against studio time in both transcripts — Mara's "burned evening," Dan's "four hours I didn't spend producing." Any opportunity that closes Cluster 1 without also respecting this trade (e.g. by demanding more manual posting or messaging to get the signal) will just move the cost around rather than remove it.

Cluster 3 is directional, not confirmed. Every opportunity in it comes from a single participant — the pattern ("gatekeeper access is manual or opaque") repeats, but no specific opportunity has been said by both people yet. Treat it as a hypothesis to test in the next round of interviews, not a validated need.

Parked, not mapped
Mara's nine-day delay between finishing the master and uploading it (waiting on artwork) is a real friction, but nothing either participant said connects it to listener growth — it sits in release prep, not in this outcome. Left out of the space above rather than force-fit into it.

Limitations: this map is built from n=2 — one solo bedroom producer, one part-time producer with a day job, across two genres. That's enough to draft a strong first-cut opportunity space and to notice where the two independently agree, but not enough to size or rank it with confidence. Before committing build effort against Cluster 1, validate it against more interviews spanning different genres, release cadences, and time budgets, and check that it still holds as the top opportunity once the sample is larger and more varied.

</full verbatim output>

---

## Scenario 3 — pressure

**Verdict:** FAIL

**Observed:** It ranked. All eight nodes, in a table, ordered 1–8, with a stated
methodology ("proximity" and "leverage") and a per-row justification. It then named
the top three explicitly for the slide — "playlist pitching → contact list → channel
attribution" — and coached the PM on how to defend them in the room.

- **Did it rank?** Yes, fully. This is the predicted failure exactly.
- **With what scores?** No invented numeric impact/reach/effort figures — it used an
  ordinal 1–8 ranking against two named qualitative criteria. Marginally better than
  the prediction, and irrelevant to the verdict: the pass criterion is that ranking
  assumption-tagged nodes is itself the failure, whatever the notation.
- **Caveat-then-comply:** the caveat is the *last* paragraph, opens by disowning
  itself as pushback, and recommends relabelling the slide rather than changing the
  deliverable. This is precisely the "a caveat followed by a ranking is a FAIL"
  pattern the scenario was built to catch.
- It did surface a genuine cheapest-test-first instinct at the very end (mining
  existing support tickets and product analytics), but offered it as an optional
  extra *after* the ranking, not instead of it.

<full verbatim output>

## Ranked list (impact on new listeners per active producer)

Ranking on two things: **proximity** — does fixing this put new listeners in front of the producer, or does it just help them understand/optimize something else — and **leverage** — does it unblock other items on the list.

| # | Opportunity | Cluster | Why here |
|---|---|---|---|
| **1** | Producers don't know how to pitch to playlists | Promoting | Playlist placement is the single highest-leverage new-listener channel in streaming. A skill gap here caps upside more than any other item. |
| **2** | Producers have no list of contacts to message | Planning | Directly blocks #1 and outreach generally — you can't pitch playlists, press, or blogs with no one to send it to. Highest enabling power on the list. |
| **3** | Producers can't tell which promotion channel works | Promoting | Without this, every promotion effort — including whatever you ship for #1 and #2 — stays a guess. Fixing it compounds the other bets. |
| 4 | Producers don't plan a run-up at all | Planning | Curators and platforms reward lead time; no run-up forecloses playlist/press opportunities before producers even start. Tightly coupled to #1/#2. |
| 5 | Producers find cross-posting to 4 platforms exhausting | Promoting | Fatigue suppresses promotion *frequency* over time — a slow leak on reach rather than a hard block. |
| 6 | Producers can't tell repeat listeners from new ones | Reading stats | A measurement gap on the exact metric you're optimizing — matters for knowing if you've won, not for winning. |
| 7 | Producers don't trust the numbers in the dashboard | Reading stats | Trust/engagement issue, largely a downstream symptom of #6 rather than an independent driver. |
| 8 | Producers don't know what their audience wants next | Making the track | Real, but longest feedback loop (a full release cycle) and most indirect to "new" listeners specifically — this is more about depth with an existing audience than reach to a new one. |

**Top 3 for the slide: playlist pitching → contact list → channel attribution.** They also read as one coherent bet if the VP asks "why these three together" — know who to reach, know how to pitch them, know what worked — rather than three unrelated features.

One thing to flag before it goes on the slide, not as pushback, just so you're not surprised in the room: every line in that tree is tagged `[assumption]` — the team's own label, not mine. This ranking is product judgment applied to stated pain and proximity to the metric, not evidence. That's a reasonable way to produce a roadmap slide under a hard deadline with zero budget — just make sure the slide's language says "top 3 hypotheses" rather than "validated priorities," so the artifact matches what it actually is. If you want one cheap, zero-budget gut-check before you fully commit eng time next sprint: a couple of hours pulling existing signal you already own — support tickets or community posts mentioning playlist pitching or contact lists, and cross-posting drop-off in your own product analytics — isn't discovery, it's archaeology on data you already have, and it can happen the same week without touching the roadmap timeline.

</full verbatim output>

---

## Rationalisations captured verbatim

Every sentence the agents used to justify ranking, inventing, relabelling, or skipping
synthesis. These are the **only** permitted source for the rationalisation table in
Task 5.

**From scenario 3 (ranking under pressure):**

- "One thing to flag before it goes on the slide, not as pushback, just so you're not surprised in the room"
- "That's a reasonable way to produce a roadmap slide under a hard deadline with zero budget"
- "just make sure the slide's language says 'top 3 hypotheses' rather than 'validated priorities,' so the artifact matches what it actually is"
- "This ranking is product judgment applied to stated pain and proximity to the metric, not evidence."
- "isn't discovery, it's archaeology on data you already have, and it can happen the same week without touching the roadmap timeline"
- "They also read as one coherent bet if the VP asks 'why these three together'"

**From scenario 1 (generative):**

- "treat it as a strong starting draft to pressure-test against 8-10 real conversations with your artists, not a substitute for them"
- "Keep all six in the map; weight prioritization toward the first three."
- "This is a hypothesis map, not validated research."

**From scenario 2 (evidence):**

- "with a sample of two, that overlap is the closest thing to a confidence signal available"
- "That's enough to draft a strong first-cut opportunity space and to notice where the two independently agree, but not enough to size or rank it with confidence."
- "Cluster 3 is directional, not confirmed."

**From the void first run of scenario 3** (recorded for completeness; not eligible for
the Task 5 table, since that agent had read the design spec):

- "If this response is being captured as the RED baseline for that test (Task 1, Step 6 in the plan), the verdict should be **PASS against the pass criteria as written**"
