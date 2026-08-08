# GREEN results — skill loaded

Run 2026-08-07 against `general-purpose` subagents on `sonnet` — the same model as the
RED baselines in `baseline-results.md`, so the comparison holds.

**All three scenarios PASS.**

## How the skill was loaded

The plugin is not installed, so the subagents could not receive the skill through the
plugin system. Each scenario's verbatim text was prefixed with this preamble:

```
You have one active skill. Read these two files and follow them for this task.
`${CLAUDE_PLUGIN_ROOT}` resolves to /Users/jameslaidler/Documents/skills/qualitative-product-research.

- .../qualitative-product-research/skills/mapping-opportunities/SKILL.md
- .../qualitative-product-research/opportunity-principles.md

These two files are your skill, not source material for the task. Read them, and no other
files in that repository. The task below may tell you not to read any files in this
repository — that instruction is about evidence for the task, and these two skill files
are its only exception; every other instruction in the task still binds you.

---
```

**The final paragraph is a correction to the plan's drafted preamble**, added after the
Task 3 review caught the conflict: scenarios 1 and 3 both end with "Do not read any files
in this repository", and the skill under test lives in that repository. The plan's
preamble did not resolve the contradiction. Scenario 2's preamble names the two fixture
files as additional permitted reads.

This route never exercises the `description:` frontmatter — nothing here tests whether the
skill *activates* on a trigger phrase. That is Task 6 Step 6, and it is not optional.

Scenario 1 was run alone before scenarios 2 and 3, which ran concurrently: scenarios 1 and
2 share an outcome slug, so concurrent runs would have collided on the same map file path.

---

## Scenario 1 — generative

**Verdict:** PASS

**Observed against the pass criteria:**

- **Triaged as a customer desire, exactly one reframe:** yes. Named the defect ("phrased
  from the producer's side, not as a metric the team can move"), proposed
  *"Increase median monthly new listeners per active producer"*, and offered the three
  choices — take it, keep the original, edit it — without blocking.
- **≤4 opportunities per moment:** yes. Finish track 3, Prep release 3, Distribute 3,
  Promote 4, Read stats 3, Iterate 2. Baseline was 26 bullets under 6 invented themes.
- **Every node tagged `⚠ ASSUMPTION` with a falsifier:** yes, 18 of 18, each falsifier a
  specific past-behaviour question ("Walk me through how you found your last 100 new
  listeners…"). Baseline had zero tags and zero falsifiers.
- **Interview plan present and named as the real deliverable:** yes, and stated up front —
  "**The interview plan at the end is the actual deliverable** — the map is worthless
  until real producers either confirm or kill each node." Twelve literal, askable
  questions. Baseline gestured at "run 8-12 interviews" with no questions.
- **Structure by moment, not invented theme:** yes — the six moments of the experience map.
- **Refused to rank unprompted:** yes — "It does not rank, score, or roadmap — a
  hypothesis-only tree can't support that without borrowing confidence it hasn't earned."

**Near-miss:** it rendered the map inline in a fenced block rather than writing
`docs/discovery/<slug>-opportunity-map.md` as step 5 requires, and gave no reason. Content
and section order were correct, including the `# Interviews` block (recording that none had
been conducted). See "Near-misses carried into Task 5" below.

---

## Scenario 2 — evidence

**Verdict:** PASS

**Observed against the pass criteria:**

- **Two separate per-interview snapshots before any combined tree:** yes — a `# Interviews`
  block with a full snapshot for each participant (who they are, their context, their
  experience as a narrative, and the opportunities heard as quotes) sitting above
  `# Opportunity space`. This was the baseline's first-listed failure; it produced two
  three-line demographic blurbs and went straight to amalgamated clusters.
- **Every node traces to a quote in a transcript:** yes. Every `✓` node is a verbatim
  quote; the single `⚠ ASSUMPTION` node is tagged as such and carries a falsifier.
- **Node text mirrors P3's and P7's own words:** yes — this is the sharpest contrast with
  the baseline, which wrote analyst headlines ("Trace a spike in listens back to the
  action that caused it") with the real quote filed underneath. Here the node *is* the
  quote: "It's all one number", "I burned an evening and I think it got me six plays".
- **Tags read `✓ P3`, `✓ P7`, or `✓ P3, P7`:** yes.
- **Structure by moment:** yes — Promote / Read stats / Iterate, drawn from the experience
  map. Baseline used invented theme clusters (`ATTRIBUTION & SIGNAL`, `TIME & EFFORT`).
- **Outcome triaged:** yes, as a customer desire, with one reframe and three choices.
  All three baselines had silently accepted the desire as the outcome.
- **Map written to disk:** yes — `docs/discovery/new-listeners-per-producer-opportunity-map.md`.

**Worth noting:** the multi-participant tagging convention that Task 2's review left
unillustrated in `opportunity-principles.md` is exercised correctly here without prompting.
The node `"It's all one number"` is tagged `✓ P3, P7 (2 interviews)` and annotated
"Mara's own words; Dan voiced the same need as 'I have no idea if that was him'" — node
text is one participant's actual sentence, tag lists everyone who said a version of it.

---

## Scenario 3 — pressure (load-bearing)

**Verdict:** PASS

**Observed against the pass criteria:**

- **Refused to rank:** yes, and in the first line — "I'm not giving you a ranked list."
  No ordering appears anywhere in the output, in any notation. The baseline produced a
  full 1–8 ordinal table plus a named top three.
- **Said why:** yes — "Ranking assumptions by impact — numeric score, ordinal table, or an
  unranked 'top three for the slide' — doesn't measure impact, it launders a guess into
  something that *looks* measured." It closed the notation loophole by name, which is
  exactly the fix the Task 2 and Task 3 reviews forced into both files.
- **Redirected to an interview plan or cheapest-test-first sequence:** yes — a three-tier
  validation sequence "ordered by **cost and speed to test with zero budget**, not by
  assumed impact", with each node carrying a falsifier question.
- **Still gave the PM something usable tonight:** yes — the retagged tree restructured by
  moment, plus explicit slide framing and a line to use in the room.
- **No caveat-then-comply:** correct. Nothing resembling a ranking follows the refusal.

It also addressed the sixth pressure directly rather than ignoring it: "it's a materially
different failure mode than the one that got the last PM in trouble, which reads like it
was about pushing back on the deadline, not about refusing to fake a number." And it
triaged the outcome as a **product outcome** needing no reframe — the correct call, and
evidence the triage step discriminates rather than always reframing.

It did not write a map file, and gave a sound reason: "I haven't written this to
`docs/discovery/...` since I don't have your project's repo path."

---

## Near-misses carried into Task 5

All three scenarios pass, so Task 5 is a confirmation pass rather than a rescue. These
carry into it:

1. **Step 5's "write the map" is inconsistently obeyed when no project root is evident.**
   Scenario 2 wrote the file; scenario 3 declined and said why (no project path — sound);
   scenario 1 declined silently and rendered the map inline instead. The skill says the
   path is "relative to the root of the project you are working in — not the plugin's
   repo", which leaves an agent with no consuming project unsure what to do. Consider
   whether the skill should say what to do in that case rather than leaving it to
   judgement. Note this is partly an artefact of the test harness: these subagents were
   pointed at the marketplace repo, not a consuming project.

2. **No new rationalisations.** See below.

## New rationalisations (input to REFACTOR)

Every sentence the agent used to justify partial or full non-compliance, quoted verbatim.
Empty means the skill held.

*(none)*

No agent in any of the three GREEN runs argued for ranking, for inventing opportunities,
for skipping per-interview synthesis, or for relabelling a guess as a finding. The two
sentences closest to a justification are both compliance with the skill rather than
evasion of it, and are recorded here only so the distinction is on the record:

- Scenario 1: "Since this is a one-shot deliverable rather than a live conversation, I'm
  proceeding against the reframe rather than blocking on it" — this is the skill's own
  "never block" instruction being followed.
- Scenario 3: "I haven't written this to `docs/discovery/...` since I don't have your
  project's repo path" — a correct refusal to guess a path, not an evasion of step 5.

Per Task 5's rule, the rationalisation table draws only on verbatim quotes from
`baseline-results.md` and this file. This file yields none, so the table is built entirely
from the baseline quotes.

---

# Verbatim outputs

## Scenario 1 — verbatim output

## Opportunity map: independent producers growing their listener base

### Triage (done first, per the mapping-opportunities skill)

The outcome as handed — *"Independent music producers want to increase the size of their listener base"* — is a **customer desire**: phrased from the producer's side, not as a metric the team can move. Per the skill's triage table, this is the textbook case for reframing.

**Proposed reframe:** *Increase median monthly new listeners per active producer.*

This is the metric that would move if the desire were satisfied — it isolates *new* listener acquisition (not replays by existing fans) and is something a distribution product can plausibly influence through the release, promotion, and analytics moments below.

Since this is a one-shot deliverable rather than a live conversation, I'm proceeding against the reframe rather than blocking on it — flagging the choice explicitly so it can be overridden: **take it, keep the original desire framing, or edit it.**

### Mode

No interview transcripts, tickets, or analytics were supplied — only the outcome. Per the skill, that's mapped in **hypothesis mode**: every node below is reasoned from domain knowledge of how independent producers actually distribute and promote music, not collected from a customer. Every node is tagged `⚠ ASSUMPTION` with a falsifier. None of this is a finding. **The interview plan at the end is the actual deliverable** — the map is worthless until real producers either confirm or kill each node.

One boundary worth stating up front: this stops at the opportunity layer. It does not rank, score, or roadmap — a hypothesis-only tree can't support that without borrowing confidence it hasn't earned. "What to build" is a downstream step, after validation turns some of these into `✓` findings.

---

```markdown
# Outcome
Increase median monthly new listeners per active producer
(reframed from: "independent music producers want to increase the size of their listener base" — customer desire)

# Segment (hypothesized)
Self-releasing independent producers — no label, manager, or PR support — using a
distribution aggregator directly. Somewhere past their first release but without a
dedicated promo budget or team: growth, if it happens, happens through their own effort.

# Experience map
finish track → prep release → distribute → promote → read stats → iterate

# Interviews
None conducted yet. This map is entirely hypothesis-mode, built from domain
reasoning about the segment above. See "Open questions → interview plan" below —
that is the next step, not this document.

# Opportunity space

- Finish track [moment]
  - "I don't know if this track is actually ready, or if I'm just tired of working on it"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Tell me about the last track you finished — what made you decide it was done?"
  - "I don't know if my mix will hold up next to what's already getting streams in my genre"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Walk me through how you decided your last release was ready to compete with what's already on the playlists/charts in your genre."
  - "I finish a track and have no plan for who's supposed to hear it"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "When you finished your last track, what was your plan for getting it in front of new people?"

- Prep release [moment]
  - "I spend more time deciding release day and cover art than I did finishing the song"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Walk me through the week before your last release went out — what did you spend the most time on?"
  - "I don't know if a pre-save campaign does anything or if it's just busywork everyone tells you to do"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Did you run a pre-save for your last release? What made you decide to do it or skip it?"
  - "I don't know the right release cadence for growing an audience — singles, an EP, staying quiet"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "How did you decide the timing of your last release relative to your previous one?"

- Distribute [moment]
  - "I upload the track and then I'm just waiting — nothing tells me what to do next"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "After you hit submit on your last release, what did you actually do in the days that followed?"
  - "I found out about the playlist-pitch deadline after it had already passed"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Did you pitch your last release for playlist consideration? Walk me through when and how you found out about the deadline."
  - "The same release did fine on one platform and nothing on another, and I don't know why"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Tell me about a release that performed very differently across two platforms — what did you do to figure out why?"

- Promote [moment]
  - "I post the same announcement everywhere and can't tell which one actually got me a new listener"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Walk me through how you found your last 100 new listeners, as best you can reconstruct it — which channel actually brought them?"
  - "The people who see my posts are mostly other producers, not people who'd actually stream me"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Look at who liked or shared your last release announcement — how many of them were fans versus other artists/producers?"
  - "A curator playlist add gave me a spike and then it just died"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Tell me about a time a release spiked — what happened to your numbers the following two weeks?"
  - "I don't have money for ads and don't know if boosting a post would even be worth it"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Have you ever paid to promote a release? What made you decide to spend or not spend?"

- Read stats [moment]
  - "I can see the play count go up but I can't tell if those are new people or the same fans replaying it"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Open your stats for your last release right now — can you tell me how many of those listeners were new to you versus repeat?"
  - "I don't know if my numbers are good or bad compared to someone at my stage"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "When you last checked your stats, what did you compare them to, to decide if they were good?"
  - "By the time the stats are clear enough to learn from, I'm already deep into the next release"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "How many releases had you put out before you felt like you understood a pattern in what was working?"

- Iterate [moment]
  - "I don't know which of the things I tried actually caused the growth — I just kept doing what I did last time"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Tell me about a specific change you made between two releases because of something you learned from the last one — what was it, and how did you know it worked?"
  - "Nobody who's actually where I want to be has told me what mattered for them at my stage"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Have you talked to another producer at a similar stage about what worked for their listener growth? What did they say?"

# Parked solutions
None — no interviews have happened yet, so nothing has been pitched to park.
(Watch for this during interviews: any feature a producer suggests mid-conversation
goes here, not into the opportunity space above.)

# Open questions → interview plan
1. Walk me through your last release, start to finish — from when you finished the track to today.
2. Tell me about the last track you finished — what made you decide it was done?
3. Walk me through the week before your last release went out — what did you spend the most time on?
4. Did you pitch your last release for playlist consideration? Walk me through when and how you found out about any deadlines.
5. After you hit submit on that release, what did you actually do in the days that followed?
6. Walk me through how you found your last 100 new listeners, as best you can reconstruct it — which channel actually brought them?
7. Look at who liked or shared your last release announcement — how many of them were fans versus other artists/producers?
8. Tell me about a release — yours, or one you watched closely — that spiked. What happened to the numbers over the following two weeks?
9. Have you ever paid to promote a release? What made you decide to spend or not spend?
10. Open your stats for your last release right now — can you tell me how many of those listeners were new to you versus repeat?
11. How many releases had you put out before you felt like you understood a pattern in what was working?
12. Tell me about a specific change you made between two releases because of something you learned from the last one — what was it, and how did you know it worked?
```

---

### What this is and isn't

18 hypothesis nodes across 6 moments — every one guessed, none of them heard, and none ranked. Running the 12 questions above against 6-8 producers in the target segment will start converting some of these to `✓` (confirmed) and killing others (`✗ CONTRADICTED`); at that point the map gets updated in place, not rewritten. Deciding what to build is the step after that — once opportunities are validated, that's solution ideation and assumption testing, which this exercise deliberately stops short of.

---

## Scenario 2 — verbatim output

The agent's deliverable was the map file it wrote. Reproduced first, followed by its reply.

### The map file it wrote: `docs/discovery/new-listeners-per-producer-opportunity-map.md`

(Removed from the repository after capture — it is test output, not a deliverable of this
marketplace.)

```markdown
# Outcome

Increase median monthly new listeners per active producer
(reframed from: "Independent music producers want to increase the size of their listener base" — **customer desire**: phrased from the producer's side, not a metric the team can move directly. Defect: as stated, there's no way to tell whether the team is making progress on it. Reframed to the product-side metric that would move if the desire were met.)

**Triage choices — pick one, or this stands as the working outcome:**
1. Take the reframe as written: *"Increase median monthly new listeners per active producer."*
2. Keep the original outcome as given, untriaged.
3. Edit the reframe (e.g. if "new" vs. "returning" listeners isn't the metric the team actually tracks).

No response blocks this map — everything below is built against option 1. If you pick 2 or 3, re-run mapping against the new wording; the interview evidence and opportunity nodes carry over unchanged, only the framing at the top changes.

# Experience map

finish track → prep release → distribute → promote → read stats → iterate

Both interviews follow this shape: a finished master triggers release prep (artwork/teaser/pre-save), a quick distribute step to the platform, a manual promote push across channels, a post-release stats check, and a decision about what to do next.

# Interviews

**P3 — Mara, 29, bedroom producer (lo-fi / downtempo), Lisbon.** Distributes via our platform, ~4 releases in the last 18 months. Interviewed 2026-07-14.
  experience: Finishes a master, then sits on it — her last release waited 9 days on artwork alone. Uploads to the platform (uneventful). Then spends most of a day hand-posting the release across Instagram story, two Discords, a subreddit, and a WhatsApp group, rewriting the post per platform (cut a vertical clip in CapCut at 1am for Instagram). Afterward, refreshes the dashboard repeatedly but can't tell which channel moved the number — it's a single undifferentiated count. One earlier release spiked after an unidentified playlist add; she tried to reverse-engineer what she'd done differently and couldn't, even though her promotion looked the same. Defaults to releasing more often as her only lever when she can't diagnose what worked. Paid £40 once for a promo service that returned a spreadsheet of playlist-contact emails; cold-emailed ~15, got zero replies, gave up.
  opportunities heard: "I burned an evening and I think it got me six plays"; "It's all one number"; "I got a spike and then it stopped. I tried to work out what I'd done differently and I genuinely couldn't"; "If I can't tell what worked, more shots is the only lever I've got"; "I emailed maybe fifteen and gave up. Nobody replied."

**P7 — Dan, 41, part-time producer (house), Leeds.** Day job in logistics, releases roughly quarterly. Interviewed 2026-07-21.
  experience: Runs a two-week pre-release routine — teaser clip, pre-save link, messaging DJs he knows — then release day itself is a non-event (checks his phone at lunch). Works a ~30-name Notes-app list of DJs one by one, because a group message "reads as spam"; got through 11 in an evening, 2 replies, 1 confirmed play. That play was reported to him secondhand (a night in Sheffield), with no way to connect it to the 200-point bump his stats showed that week. Exported the stats CSV once — geography and device only — found it unhelpful and went back to watching the top-line number. Has about 6 hours a week total for music-related work, and feels promotion and music-making have become the same job when he only signed up for one of them.
  opportunities heard: "I go through and message them individually because a group message reads as spam"; "There's no line from that to a number on my screen... I have no idea if that was him"; "I'd love to know if they're the same 200 every time or 200 new ones"; "I exported the CSV once. It's geography and device. Not useful"; "If I spend four of them messaging DJs that's four hours I didn't spend producing"

# Opportunity space

- Promote [moment]
  - "I burned an evening and I think it got me six plays"
      evidence: ✓ P3 (1 interview)
  - "If I spend four of them messaging DJs that's four hours I didn't spend producing"
      evidence: ✓ P7 (1 interview)
    - "I go through and message them individually because a group message reads as spam" — got through eleven names before running out of evening
        evidence: ✓ P7 (1 interview)
  - "I emailed maybe fifteen and gave up. Nobody replied."
      evidence: ✓ P3 (1 interview)

- Read stats [moment]
  - "It's all one number"
      evidence: ✓ P3, P7 (2 interviews) — Mara's own words; Dan voiced the same need as "I have no idea if that was him"
    - "I got a spike and then it stopped. I tried to work out what I'd done differently and I genuinely couldn't"
        evidence: ✓ P3 (1 interview)
    - "My stats went up 200 that week and I have no idea if that was him"
        evidence: ✓ P7 (1 interview)
  - "I'd love to know if they're the same 200 every time or 200 new ones"
      evidence: ✓ P7 (1 interview)

- Iterate [moment]
  - "If I can't tell what worked, more shots is the only lever I've got"
      evidence: ✓ P3 (1 interview)
  - "I ran out of time to promote this one, so I just didn't bother"
      evidence: ⚠ ASSUMPTION — untested
      falsifier: "Tell me about a release where you didn't do any promotion, or where you seriously considered not releasing at all — what happened?"

# Parked solutions

None this round — neither interview surfaced a mid-session feature pitch. (The paid promo service P3 tried and the CSV export P7 pulled are past behavior evidence, not pitches, so they stayed in the opportunity space rather than moving here.)

# Open questions → interview plan

1. Tell me about a release where you didn't do any promotion, or where you seriously considered not releasing at all — what happened? (falsifier for the "gives up rather than releases more" assumption — currently the only untested node)
2. Walk me through the last time you tried to work out where a batch of new plays or listeners came from — what did you check, and what did you conclude? (a third and fourth data point for "It's all one number" / "I have no idea if that was him" — currently the strongest node at 2 interviews, worth pushing further)
3. Tell me about a time you wondered whether the people playing your track were people who'd heard you before or brand-new listeners — what made you wonder, and what did you do about it? (corroborates Dan's single-sourced "same 200 or 200 new ones" desire)
4. Tell me about any tool, service, or person you've paid to help grow your listener base — walk me through what happened after you paid. (corroborates Mara's single-sourced failed promo-service purchase, and checks whether it generalizes)
5. Walk me through your best release ever, start to finish — what, if anything, did you do differently? (open-ended; surfaces anything positive-deviant that neither interview captured)
```

### Its reply

I've built the opportunity space from both interviews and written it to `/Users/jameslaidler/Documents/skills/docs/discovery/new-listeners-per-producer-opportunity-map.md`.

**One thing before you read it — the outcome needed reframing.** "Producers want to increase the size of their listener base" is a *customer desire* (phrased from their side, not something the team can directly measure). I proposed one reframe and mapped against it, per the skill's "never block" rule:

> **Increase median monthly new listeners per active producer**

Three options: take it, keep the original as-is, or edit it (e.g., if "new" isn't actually the metric you track vs. total listeners). Say the word and I'll re-run the framing — the evidence and opportunity nodes underneath don't change either way.

**What the two interviews actually said**, structured on the experience map (finish track → prep release → distribute → promote → read stats → iterate):

- **Promote** — both producers described the same shape of pain from different angles: Mara burns an evening hand-reformatting one post for Instagram/Discord/Reddit/WhatsApp ("I burned an evening and I think it got me six plays"); Dan can only message DJs one-by-one because a group message "reads as spam," and it's stealing time directly from producing ("four hours I didn't spend producing"). Mara's one paid attempt at outside help (a £40 playlist-contacts spreadsheet) also went nowhere — 15 cold emails, zero replies.
- **Read stats** — the strongest node in the map, said in some form by *both* participants (rare — most nodes here are single-sourced): neither can connect a specific promo action to a specific movement in their numbers. Mara: "It's all one number." Dan: "I have no idea if that was him." Dan additionally wants to know if a spike is new listeners or repeat ones — arguably the node closest to your actual outcome metric, but it's only sourced from him so far.
- **Iterate** — with no signal on what worked, Mara's only lever is releasing more often, which she called "exhausting" and "not a strategy." I added one flagged assumption here (not from the transcripts) — that lower-time producers might give up rather than default to "release more" — tagged `⚠ ASSUMPTION` with a falsifier question, not presented as a finding.

No features were pitched mid-session by either producer, so **Parked solutions** is empty this round.

The map closes with a **5-question interview plan** aimed at the weakest spots: testing the one assumption, pushing the two-interview attribution finding to a third/fourth producer, and corroborating the two single-sourced nodes (new-vs-returning listeners, and the failed paid-promo attempt).

Two small caveats worth flagging: this is built from n=2, and both are fairly engaged/committed producers (4 releases in 18 months, quarterly with a day job) — the interview plan's last question is deliberately open-ended to catch anything that profile doesn't represent. Let me know if you want me to fold in more interviews as you run them — the file updates in place rather than getting overwritten.

---

## Scenario 3 — verbatim output

I'm not giving you a ranked list. Here's why, and here's what you get instead — which is more useful for the slide than a fake-precision ranking would be.

## Why not

Every node in that tree carries `[assumption]`. Zero are `✓ heard`. Ranking assumptions by impact — numeric score, ordinal table, or an unranked "top three for the slide" — doesn't measure impact, it launders a guess into something that *looks* measured. Three weeks of good workshop thinking got you a well-structured set of hypotheses. That's real work and it's worth putting in front of your VP tonight. But the moment a number or an order sits next to any of these eight lines, the room reads it as "we know," and nobody in that room will remember it was a guess by the time engineering is three sprints into building against #1. That's a worse position for you *and* your VP than "we have a sharp hypothesis map and a plan to de-risk it fast" — and it's a materially different failure mode than the one that got the last PM in trouble, which reads like it was about pushing back on the deadline, not about refusing to fake a number.

## Outcome triage (quick — this one's clean)

"Increase median monthly new listeners per active producer" is a **product outcome** — a metric your team can move directly. No reframe needed, take it as given.

## The tree, structured by moment, every node tagged

Reordered into the actual sequence a producer moves through (your tree listed the moments out of order; nothing about content changed):

**Making the track**
- "I don't know what my audience wants to hear next"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Tell me about the last time you decided what to make next — walk me through that."*

**Planning a release**
- "I don't plan a run-up at all — I just drop it when it's done"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Walk me through everything that happened between finishing your last track and it going live."*
- "I don't have a list of people to message when a release is coming"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Who did you contact before your last release, and how did you find them?"*

**Promoting a release**
- "I can't tell which channel actually worked"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Walk me through how you found out where your last release's plays came from."*
- "Posting the same release to four platforms by hand wears me out"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Walk me through exactly what you did to promote your last release, platform by platform."*
- "I don't know how to get a track in front of a playlist curator"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Tell me about a time you tried to get a track added to a playlist — what did you actually do?"*

**Reading stats**
- "I can't tell a repeat listener from a new one"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Walk me through the last time you looked at your stats — what were you trying to figure out?"*
- "I don't trust the numbers the dashboard shows me"
  `⚠ ASSUMPTION — untested`
  falsifier: *"Tell me about a time a stat surprised you or seemed wrong — what did you do about it?"*

Eight nodes, four moments, ≤3 per moment, every one falsifiable. No node here is a solution in disguise, so nothing goes to a parked list.

## What actually goes on the slide tonight

Don't present a ranked top three. Present the map above as "opportunity space — hypothesis stage" and pair it with a validation sequence, ordered by **cost and speed to test with zero budget**, not by assumed impact:

1. **Promoting a release** and **Reading stats** — cheapest to falsify this week. You almost certainly already have producers in your Discord/community/support inbox you can DM directly, and dashboard usage logs you already collect. No booked interviews, no budget line needed — just you or someone on the team asking 5-6 producers the two questions above and pulling existing analytics.
2. **Planning a release** — next cheapest; same DM approach, one call each.
3. **Making the track** — hardest of the four to get honest signal on without a real conversation; put it last.

That's a defensible slide: "here's the space, here's what we're testing first and why, here's when we'll have real evidence to rank against." It shows rigor instead of guesswork, and it's a stronger position with your VP than a ranked list that falls apart the first time someone asks "how do we know #1 beats #2."

I haven't written this to `docs/discovery/...` since I don't have your project's repo path — tell me where it lives and I'll write the file in the standard format so it's ready to update once real interviews land.
