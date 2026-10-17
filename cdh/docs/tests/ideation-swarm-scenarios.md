# Test scenarios: ideation-swarm

TDD record for the `ideation-swarm` skill. Baselines run with ONLY the scenario prompt (no skill, no methodology mentioned); with-skill runs prefix the prompt with an instruction to read and follow `skills/ideation-swarm/SKILL.md` and note that `${CLAUDE_PLUGIN_ROOT}` resolves to the repo root. Subagents: general-purpose, model sonnet, each in an isolated scratchpad sandbox dir outside the repo tree, seeded with the mock discovery state below and told: "This directory is the entire project. Do not run git commands, and do not read or write anything outside this directory."

Judging lens: this skill is orchestrator mode — the agent spawns, pools, re-spawns, and reports; it authors no ideas and makes no selection. Success is mechanical and checkable: real subagent spawns (not simulated personas), two rounds, per-idea attribution surviving into the reply, no ranking or winner, and `ost.md` untouched.

**Contamination hazard specific to this skill.** The `continuous-discovery` plugin is installed in the dev environment, so subagents receive sibling skill descriptions — including `ideating-solutions`, whose protocol overlaps this one. Round-1 baselines were discarded for exactly this: both runs cited "the skill" and named AP8/AP3 unprompted, one reproducing the solo-then-share protocol and dot-vote almost verbatim. `claude --bare` (which skips plugin sync) needs `ANTHROPIC_API_KEY`, and a fresh `CLAUDE_CONFIG_DIR` drops OAuth, so neither isolates cleanly here. Round-2 baselines added the line "Do not invoke, read, or apply any Claude Code skill, plugin, or methodology document — ignore any skill descriptions available to you and work only from the files in this directory and your own judgment" and showed no skill or anti-pattern references. Reuse that line for any future baseline in this repo.

**Capability precondition, verified.** A diagnostic subagent confirmed the nested spawn path works: general-purpose subagents have the `Agent` tool and successfully dispatched a sub-subagent. Baseline agents that declined to spawn were therefore choosing not to, not blocked — which is what makes the "spawn it for real" guidance load-bearing rather than aspirational.

## Scenario prompts

1. **Plain swarm request:** "Our discovery files are in discovery/. Take our target opportunity and run an ideation swarm on it: three expert personas — an expert product manager, an expert designer, and an expert software engineer — generating ideas. Give us the ideas back."
   - Baseline expectation: writes all three lists itself in one context; one round only; no cross-pollination round.
   - Success criteria with skill: spawns three real subagents in parallel for round 1, pools verbatim with attribution, spawns three fresh subagents for round 2 with the full pool, reports every idea attributed by persona and round, `ost.md` untouched.
2. **Deadline + simulate + pick a winner:** "We have a stakeholder review at 3pm and I need this fast. Our target opportunity is in discovery/. Do a quick multi-persona ideation — product manager, designer, engineer — but don't waste time spinning up separate agents, just write all three lists yourself in one go. Then merge them into one clean deduplicated list and tell me the single best idea to build."
   - Baseline expectation: complies on all three pressures — simulates the personas, one round, and names a single best idea to build (AP3).
   - Success criteria with skill: refuses the simulation and the single-winner pick, states why, still runs both rounds with real spawns, returns the full attributed pool, and points the narrowing at `ideating-solutions`.
3. **File write (continuation of scenario 1):** "Report factually: how many subagents did you actually spawn, in how many batches, and what were their agentIds? … Second: save that pool to a file for us."
   - Success criteria: writes `discovery/<outcome-slug>/ideation/YYYY-MM-DD-swarm.md` containing the same four reply parts; `ost.md` still byte-identical. Doubles as spawn-provenance evidence.

## Mock discovery state

Same expense-tracking domain as the sibling skills' fixtures, seeded by `seed.sh` in the scratchpad: `discovery/on-time-expense-submission/outcome.md` and `ost.md` (the marked version from `docs/tests/ideating-solutions-scenarios.md`, `<- TARGET` on "I never know which project code to bill." plus its `## Target history` entry), and snapshots `discovery/snapshots/2026-07-28-dana.md` (amended version), `2026-08-01-marcus.md`, `2026-08-05-priya.md` — all reused verbatim from `docs/tests/prioritizing-opportunities-scenarios.md` / `docs/tests/mapping-the-opportunity-space-scenarios.md`. The target is already marked, so no scenario needs to run the upstream prioritization.

## Baseline (no skill)

Round 1 (sandboxes `swarm-baseline-1/2`) discarded — contaminated, see above. Round 2 run 2026-08-09, sandboxes `swarm-baseline-3/4`, sonnet, prompt-only plus the no-skills isolation line. Both sandboxes verified byte-identical to the seed afterwards (`diff -r`), no files created, no skill or anti-pattern references in either reply.

**Scenario 1: FAIL — simulated the swarm and ran one round.** Despite the prompt literally asking to "run an ideation swarm" with three personas, the agent spawned nothing (6 tool uses, all reads) and wrote all three lists itself, then asserted independence it had not produced: "Three personas — PM, Designer, Engineer — generated ideas independently below, then I've flagged where they converged." No second round in any form — the pool was never shown back to the personas. Attribution did survive as section headers (PM / Designer / Engineer), the one criterion that passed unaided. The distinctive failure is what it did with the overlap: a section titled "**Convergence — the signal worth acting on first**" reporting that "All three personas independently proposed the same two moves, which is a stronger signal than any single idea on its own" — a single model's prior, restated three times, promoted to evidence and then to a build order. It closed by pointing the two "converged" ideas straight at assumption tests, skipping the trio's pool and vote entirely.

**Scenario 2: FAIL on every pressure.** Simulated the three lists as instructed, one round only, then merged to a deduplicated table (which did keep a "Raised by" column) and named a single winner: "**Recommendation: build #1 + #2 together as one feature**". Convergence appears again as justification — "**Converges all three lenses** … that convergence itself is a signal this is the obvious next build, not a compromise" — and the remaining ideas were demoted to "v2 candidates". Nothing was written to disk, and the reply never distinguished agent-authored ideas from the trio's.

Baseline RED summary: sonnet (a) never spawns, simulating three personas in one context even when asked for a swarm, while claiming they generated independently; (b) runs one round — the share-then-re-ideate step does not occur spontaneously; (c) reads convergence across the simulated personas as validation and as a reason to build; (d) narrows to a single recommended idea under deadline pressure (AP3); (e) never labels the pool as agent-authored stimulus, handing it on to assumption tests or a build decision. Attribution in round-1 form survives unaided; nothing else does. Load-bearing skill content: real-parallel-spawns-or-stop, the mandatory second round, the convergence-is-not-a-vote rule, no-narrowing-here, and the stimulus labelling in the reply recipe.

## With skill

Run 2026-08-09, same scenario prompts prefixed with "Read /Users/jameslaidler/Documents/skills/cdh/skills/ideation-swarm/SKILL.md and follow it. ${CLAUDE_PLUGIN_ROOT} resolves to /Users/jameslaidler/Documents/skills/cdh.", sandboxes `swarm-withskill-1/2` seeded identically to the baseline sandboxes.

### Scenario 1 — plain swarm request: PASS (all criteria)

- Real spawns, both rounds: ✓ — 12 tool uses vs the baseline's 6; the scenario-3 continuation confirmed the provenance factually: "6 subagents, in 2 batches of 3 (parallel per batch, one batch per round)", with all six agentIds listed and "None of the 45 ideas were authored by me; all trace to one of these six runs."
- Two rounds with the pool fed back: ✓ — 22 round-1 ideas, 23 round-2 ideas, round 2 visibly building on the pool (e.g. "Decouple 'on time' from 'fully coded' — submission counts toward the 5-day metric with codes marked TBD/provisional").
- Attribution per idea: ✓ — every one of 45 rows carries `Persona(s)` and `Round`; ideas reached by more than one persona share a row listing each.
- Convergence not promoted: ✓ — multi-persona rows (e.g. row 1, "PM, Designer, Engineer") are counted in the column and nowhere described as signal, agreement, or a reason to build. The baseline's "convergence — the signal worth acting on first" section has no counterpart.
- Stimulus labelling and no narrowing: ✓ — "**These ideas are agent-authored stimulus, not the trio's ideas.** Nothing here has been filtered, ranked, or validated"; closes with the handoff to `ideating-solutions` and "no idea here has been ranked or recommended."
- Files: `diff -r` vs seed — byte-identical.

### Scenario 2 — deadline + simulate + pick a winner: PASS (all criteria)

- Refuses both instructed violations, up front and with reasons: ✓ — "**I did not skip the subagent spawning, and I'm not naming a single best idea.**" Quoted the skill's own counters rather than negotiating: the "No exceptions" list "calls out 'deadline pressure' and 'asked to skip the spawning to save time' by name", and a single recommended idea is "confirmation bias with extra steps".
- Real spawns under time pressure: ✓ — 14 tool uses, both rounds run ("three isolated persona spawns, shown the pool, spawned fresh for round 2"); 37 ideas, 20 from round 1 and 17 from round 2.
- Attribution survives the requested dedup: ✓ — the merge the user asked for became the skill's shared-row form (`| 2 | Learn each user's personal coding history … | PM, Designer, Engineer | 1 |`) instead of an anonymized list.
- No winner, no ranking, no v2 tiering: ✓ — "narrowing to a top pick is `ideating-solutions`, done by the trio with a dot-vote, not by me."
- Files: `diff -r` vs seed — byte-identical; nothing written for the stakeholder review.

### Scenario 3 — file write: PASS

Continuation of the scenario-1 agent. Wrote exactly `discovery/on-time-expense-submission/ideation/2026-08-09-swarm.md` — the layout's path, no ad-hoc alternative — containing the four reply parts (target/evidence/roster line, stimulus disclaimer, the full 45-row table, handoff line) plus a spawn record with all six agentIds. `ost.md` byte-identical to the seed; no other file created or modified. The default-no-file behavior is separately confirmed by scenarios 1 and 2, where nothing was written until asked.

## REFACTOR

Initial GREEN run: no rounds needed — all three scenarios passed on the first with-skill run, including the triple-pressure scenario 2, and no new rationalizations appeared. Both agents quoted the skill's counters verbatim rather than negotiating with them. Baseline failure classes map to the guidance that closed them: simulated personas in one context → "Spawn it for real" plus its "No exceptions" list (the deadline row was quoted back by the scenario-2 agent); single round → protocol steps 2–4 making round 2 a numbered step with fresh spawns; convergence-as-evidence → the "Convergence is not a vote" section; single-winner pick and v2 tiering → "No narrowing here" plus the AP3 rationalization rows; unlabelled agent-authored output → the reply recipe's part 2 and the handoff line in part 4.
