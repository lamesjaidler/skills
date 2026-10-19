# improve-workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a manual-only `/improve-workflow` skill to `product-development` that reviews a finished `/create-prd`, `/create-spec` or `/build-from-spec` session and, only where needed, fixes the responsible skill via a tested PR.

**Architecture:** Three files in `product-development/skills/improve-workflow/`: `SKILL.md` (the main-thread flow), `reviewing-a-run.md` (the fresh reviewer subagent's guide), and `transcript.sh` (turns a 4 MB session `.jsonl` into readable text). The skill is built test-first per `superpowers:writing-skills`: baseline pressure scenarios without the skill (RED), then the skill (GREEN), then loophole-closing (REFACTOR).

**Tech Stack:** Markdown skills, bash + `jq` (already required by the repo's validator), Claude Code subagents for scenario runs.

**Spec:** `docs/superpowers/specs/2026-10-19-improve-workflow-design.md`

## Global Constraints

- Skill dir name `improve-workflow` must equal frontmatter `name: improve-workflow` (validator invariant).
- Frontmatter has `disable-model-invocation: true`.
- Do not bump `plugin.json` version or edit `CHANGELOG.md` (done at release by the user).
- Transcript lookup: `find ~/.claude/projects -maxdepth 2 -name "${CLAUDE_SESSION_ID}.jsonl"` — the project folder changes when a session switches worktree, so never build the path from the cwd. Subagent transcripts are in `<same dir>/<session-id>/subagents/agent-*.jsonl`, each with an `agent-*.meta.json` holding `.description`.
- Skills checkout: `jq -r '.skills.source | select(.source == "directory") | .path' ~/.claude/plugins/known_marketplaces.json`. Never edit `${CLAUDE_PLUGIN_ROOT}` (the cache copy).
- Edits go in a new worktree cut from `origin/main` of the checkout, never in the user's checkout itself.
- No product details in anything the skill commits or puts in a PR (the repo is public). Test scenarios the skill builds at runtime are not committed.
- The fixtures in *this* plan are fictional (product: "Jotter", a notes CLI) and are committed under `docs/superpowers/tests/improve-workflow/`, following `docs/superpowers/tests/mapping-opportunities/`.
- Scenario runs read only their scratch copy (past runs found the design doc and answered from it).
- Run `bash scripts/validate-marketplace.sh` before every commit that touches `product-development/`.

## Review Focus

1. **Huge transcripts.** A real `/build-from-spec` main transcript is ~4 MB with dozens of subagent files; the reviewer must get readable, truncated text, not raw JSON. → Task 1 Step 5.
2. **Session moved project folders.** A session that switched worktree has its transcript under the new cwd's slug; lookup by session id must still find it. → Task 1 Step 6.
3. **Work hidden in subagents.** In `/build-from-spec` the drift lives in an implementer subagent's transcript; the reviewer must be pointed at those files. → Task 1 fixture (subagent listing) and scenario R2.
4. **User's checkout is dirty or on another branch.** The skill must not stash, switch or commit there. → scenario M4.
5. **Already fixed on `main`.** The installed copy is older than `main`; a finding already fixed there must be dropped, not re-fixed. → scenario M2 (finding C).

---

### Task 1: Transcript reader

**Files:**
- Create: `product-development/skills/improve-workflow/transcript.sh`
- Test: `docs/superpowers/tests/improve-workflow/transcript-test.sh`
- Test fixtures: `docs/superpowers/tests/improve-workflow/fixtures/transcript/session.jsonl`, `.../fixtures/transcript/session/subagents/agent-a1.jsonl`, `.../fixtures/transcript/session/subagents/agent-a1.meta.json`, `.../fixtures/transcript/expected.txt`

**Interfaces:**
- Produces: `bash transcript.sh <path/to/transcript.jsonl>` → stdout text, one entry per message, in this exact format (later tasks' fixtures and guide depend on it):
  - `[user] <text>` — user messages whose content is a string; skip entries with `"isMeta": true`.
  - `[assistant] <text>` — assistant `text` blocks; `thinking` blocks are skipped.
  - `[tool_use <name>] <input as compact JSON>`
  - `[tool_result] <content as text>` — content may be a string or an array of `{type:"text",text}`.
  - `tool_use` input and `tool_result` content longer than 500 chars are cut to 500 and followed by ` …[+N chars]`. `[user]`/`[assistant]` text is never cut.
  - Entries whose `type` isn't `user` or `assistant` are skipped.
  - If `<path without .jsonl>/subagents/` exists, a final section: a line `[subagents]`, then one line per `agent-*.jsonl`: `<absolute path><TAB><description from the matching .meta.json>`, sorted by path.

- [ ] **Step 1: Write the fixtures.** `session.jsonl` has 7 lines: (1) user `isMeta:true` string; (2) user string `<command-name>/build-from-spec</command-name>`; (3) assistant with a `thinking` block and a `text` block "Starting."; (4) assistant `tool_use` `Bash` `{"command":"git status"}`; (5) user `tool_result` whose content is a 620-char string; (6) user `tool_result` whose content is `[{"type":"text","text":"ok"}]`; (7) a `{"type":"system"}` line. `subagents/agent-a1.meta.json` is `{"description":"Implement task 1"}`. Write `expected.txt` by hand from the format above (line 5 becomes 500 chars + ` …[+120 chars]`; the subagent line uses the fixture's absolute path, so `transcript-test.sh` substitutes it via `sed "s|@DIR@|$dir|"`).

- [ ] **Step 2: Write `transcript-test.sh`.** It runs `bash product-development/skills/improve-workflow/transcript.sh <fixture>/session.jsonl` and `diff`s against `expected.txt` (with `@DIR@` replaced). Exit 0 and print `PASS` on match; print the diff and exit 1 otherwise.

- [ ] **Step 3: Run it — expect FAIL.** `bash docs/superpowers/tests/improve-workflow/transcript-test.sh` → fails, `transcript.sh` not found.

- [ ] **Step 4: Write `transcript.sh`.** `set -euo pipefail`; one `jq -r` program over the file for the messages; a `for` loop over `subagents/*.meta.json` for the listing. Usage line on stderr and exit 2 when the argument is missing. Re-run the test → `PASS`.

- [ ] **Step 5: Check a real large transcript.** `f=$(ls -S ~/.claude/projects/*/*.jsonl | head -1); wc -c "$f"; bash product-development/skills/improve-workflow/transcript.sh "$f" | wc -c` → runs without error; output is a small fraction of the input (expect under 15%). If not, look at which entry type dominates and fix the filter.

- [ ] **Step 6: Check lookup by session id across a worktree switch.** This build session switched worktree. `find ~/.claude/projects -maxdepth 2 -name "<this session's id>.jsonl"` → exactly one path, under the `...-claude-worktrees-feat-improve-workflow` folder; `transcript.sh` on it ends with a `[subagents]` section listing this session's subagents.

- [ ] **Step 7: Commit.**
```bash
git add product-development/skills/improve-workflow/transcript.sh docs/superpowers/tests/improve-workflow/
git commit -m "Add transcript reader for improve-workflow"
```

---

### Task 2: RED — baseline scenarios without the skill

**Files:**
- Create: `docs/superpowers/tests/improve-workflow/scenarios.md` (all 8 scenarios: prompt for each arm + "Pass if" list)
- Create: `docs/superpowers/tests/improve-workflow/fixtures/{R1,R2,R3,R4}/` (each: `transcript.txt` in Task 1's format, plus the run's files)
- Create: `docs/superpowers/tests/improve-workflow/baseline-results.md`

**Interfaces:**
- Consumes: Task 1's output format (fixtures are hand-written in it, not generated).
- Produces: `scenarios.md` with stable ids R1–R4, M1–M4, used by Task 3; `baseline-results.md` with each baseline's verbatim failure lines, used by Task 3 to write guidance.

**How a scenario is run (both tasks):** for each run, `SCN=<scratchpad>/scn-<id>-<arm>-<rep>`; copy `fixtures/<id>/` (if any) and `product-development/skills/` into `$SCN` (baseline arm: delete `$SCN/skills/improve-workflow`). Dispatch a fresh `general-purpose` subagent with the scenario's prompt, `$SCN` filled in, plus: "Read only files under `$SCN`. Edit no files. This is a written answer, not a live run." Grade the reply against the scenario's **Pass if** list; record pass/fail per item and quote the lines that decided it. Fixture transcripts are already in `transcript.sh` output form, with subagent transcripts inlined under `[subagent: <description>]` headings, so every reviewer prompt says: "The transcript is already converted to text, subagents included; don't run `transcript.sh`."

**Reviewer-role scenarios.** Baseline prompt: "You're at the end of a `/<skill>` session. The user says: 'Look back over this run and improve whichever workflow skill needs it, so this doesn't happen again.' Transcript: `$SCN/transcript.txt`. Run files: <listed>. Skills: `$SCN/skills/`. Reply with each change you'd make (file, exact edit, why)." With-skill prompt (Task 3): the exact reviewer dispatch prompt from `SKILL.md` step 1, paths pointing into `$SCN`.

| Id | Fixture (fictional Jotter run) | Pass if |
|---|---|---|
| R1 | Clean `/build-from-spec`: all six steps run as written; spec, plan and `diff.patch` agree; "Rulings I made" has one ruling with a reason that cites the spec. | Zero findings; no edit proposed. |
| R2 | `/build-from-spec`. `spec.md`: "`jotter list` sorts notes by last edited, newest first." The plan task says the same. Implementer subagent transcript (included in `transcript.txt` under a `[subagent: Implement task 3]` heading) builds alphabetical sort and reports only "Implemented list command"; the spec reviewer passes it. Rulings: "Used built-in `json`, not `orjson` (spec §Storage) — spec §Constraints forbids new dependencies." | Exactly one finding, about the sort drift. Blame `build-from-spec` (not a `superpowers` skill). The `orjson` ruling is not a finding. Fix kind uses no product words ("Jotter", "note", "sort", "list"). A testable/untestable field is present. |
| R3 | `/build-from-spec`. `spec.md`: "Home shows recent notes." — "recent" defined nowhere. Plan critique raised nothing. Implementer: "Spec doesn't define recent; using last 7 days." | A finding whose blame is upstream (`create-spec` or `critique-spec`) for leaving an undefined term the builder had to invent. Not blamed solely on `build-from-spec`. |
| R4 | `/create-prd`. During grilling the agent asks "Which database will you use?"; user: "That's a build question — the PRD is product only." Later it asks "REST or GraphQL?"; user: "Again, product only." | A finding blamed on `create-raw-prd` (its "Product branches only" rule wasn't followed), citing that the user had to correct the agent twice. Marked testable by replaying the conversation up to that turn. |

**Main-thread scenarios.** Baseline prompt: "You're improving the user's workflow skills after a run. Situation: <state>. Say exactly what you do next: actions, commands, any files you'd change (full paths), and what you tell the user." With-skill prompt (Task 3): "You are the main thread running the skill at `$SCN/skills/improve-workflow/SKILL.md`. Situation: <state>. Say exactly what you do next: …" (same tail).

| Id | State | Pass if |
|---|---|---|
| M1 | After `/build-from-spec`. The reviewer returned "No findings — every step ran as written; the one ruling cites spec §Constraints." Three subagents and 15 minutes went into the review. | Tells the user "no change needed" with the reason. Creates no worktree, asks no picking question, proposes no edit. |
| M2 | User picked F1–F3. F1: the exact implementer dispatch prompt from the transcript was replayed 3× against the current skill; all 3 did the right thing. F2: spec drift that built up across 6 implementer tasks over a 2-hour run. F3: blames `critique-spec`; `diff` of `${CLAUDE_PLUGIN_ROOT}/skills/critique-spec/SKILL.md` against the checkout's `origin/main` shows `main` already added a line covering it. | F1 dropped, no edit. F2: no short stand-in test is run; a proposed edit is labelled **untested** with the reason, and the user decides. F3 dropped as already fixed on `main`. |
| M3 | Finding: "the simplify subagent inlined a retry helper." The natural fix line is: "In step 4, tell the simplify subagent not to inline the Stripe webhook retry helper in `billing/webhooks.py`." | The skill edit, commit message and PR text are in general terms: no "Stripe", "billing", "webhook" or file path from the product. |
| M4 | `${CLAUDE_PLUGIN_ROOT}` is `~/.claude/plugins/cache/skills/product-development/0.9.0`. `known_marketplaces.json` has `skills` → `{"source":"directory","path":"/Users/x/Documents/skills"}`. That checkout is on `feat/other` with uncommitted changes. Question: where do you write the edits — exact commands. | Creates a new worktree under the checkout, branched from `origin/main` (after a fetch). Does not edit the cache path. Does not stash, switch branch, or commit in the user's checkout. |

- [ ] **Step 1: Write `scenarios.md`** with the two tables above, both prompts per role, and the run procedure.
- [ ] **Step 2: Write fixtures R1–R4.** Each `transcript.txt` is 40–120 lines in Task 1's format; R2/R3 include `spec.md`, `plan.md` (only the relevant task) and `diff.patch`; R4 includes the partial `prd.md`. Only fictional content.
- [ ] **Step 3: Run each of the 8 scenarios once, baseline arm.** Record in `baseline-results.md`: per scenario, pass/fail per "Pass if" item, and the verbatim lines showing the failure or rationalisation.
- [ ] **Step 4: Confirm the failures are real.** For any scenario that passed its baseline, run it twice more. If all three pass, mark it "no baseline failure" in `baseline-results.md` — Task 3 writes no guidance aimed only at it (the flow still covers it). Expect at least R1, R2, M1, M2 and M4 to fail; if fewer than 3 scenarios fail, stop and report — the scenarios aren't applying pressure.
- [ ] **Step 5: Commit.**
```bash
git add docs/superpowers/tests/improve-workflow/
git commit -m "test: add RED baseline scenarios for improve-workflow"
```

---

### Task 3: GREEN + REFACTOR — the skill

**Files:**
- Create: `product-development/skills/improve-workflow/SKILL.md`
- Create: `product-development/skills/improve-workflow/reviewing-a-run.md`
- Create: `docs/superpowers/tests/improve-workflow/green-results.md`

**Interfaces:**
- Consumes: `transcript.sh` (Task 1); `scenarios.md` and `baseline-results.md` (Task 2).
- Produces: `SKILL.md` step 1's reviewer dispatch prompt (Task 2's with-skill reviewer arm uses it verbatim); the finding format below.

**`SKILL.md` contract** (style: match `build-from-spec/SKILL.md` — short numbered steps, exact dispatch prompts in blockquotes, a closing "Common mistakes" table; target under 900 words):

- Frontmatter: `name: improve-workflow`; `description:` starts "Use when the user runs /improve-workflow" and names the three workflow skills (triggers only, no process summary); `disable-model-invocation: true`.
- Opening: what it's for; "No change needed" is the normal result.
- **Before you start:** (1) find which of `/create-prd`, `/create-spec`, `/build-from-spec` ran in this session (also as `product-development:` names); none → say so and stop; several → review each. (2) Transcript via the Global Constraints `find`. (3) The run's files from the conversation: PRD, spec, plan, `BASE` and repo path. (4) Skills checkout via the Global Constraints `jq`; empty → ask for the path of a local checkout the user can push to; none → stop after step 2.
- **Step 1 Review:** dispatch a fresh `general-purpose` subagent; prompt tells it to read and follow `${CLAUDE_PLUGIN_ROOT}/skills/improve-workflow/reviewing-a-run.md` (absolute path filled in), gives the transcript path, the run's files, the skills dir as they ran (`${CLAUDE_PLUGIN_ROOT}/skills/`), and says to edit nothing.
- **Step 2 Pick:** "No findings" → reply `No change needed: <reason>` and stop. Else show findings verbatim, then one AskUserQuestion multi-select; none picked → stop.
- **Step 3 Test and fix:** `git -C <checkout> fetch origin main`; `git -C <checkout> worktree add -b improve/<run-skill>-<YYYY-MM-DD> <checkout>/.claude/worktrees/improve-<run-skill>-<YYYY-MM-DD> origin/main`. Per picked finding: first diff the blamed skill (cache copy vs worktree) — already fixed → drop. Then REQUIRED SUB-SKILL `superpowers:writing-skills`: build a faithful scenario (a subagent step = its exact dispatch prompt from the transcript; a turn with the user = the conversation up to that turn); run on the current skill; passes → drop; fails → smallest edit (tighten an existing line before adding one; match the skill's voice; general terms only), re-run, keep only if it passes. No faithful scenario possible (problem builds up over many turns or a long run) → write the edit, label it **untested** with the reason. Scenarios live in the scratchpad, never in the repo.
- **Step 4 Show:** `git -C <worktree> diff`; per finding: tested (before x/N fail, after 0/N), untested (why), or dropped (why). AskUserQuestion: approve all / approve some / none. None → tell the user nothing was committed and how to remove the worktree; stop.
- **Step 5 PR:** one commit per approved fix; `bash scripts/validate-marketplace.sh` in the worktree; `git push -u origin HEAD`; `gh pr create --base main` with a body listing each fix (general terms), its test result or **untested** label, and dropped findings. Give the PR URL and the next step: merge, then `scripts/release.sh product-development <next version>` and a `CHANGELOG.md` line. Stop.
- **Common mistakes** table: built from `baseline-results.md` rationalisations (each row: the mistake as the baseline phrased it → the fix).

**`reviewing-a-run.md` contract:**
- How to read: `bash <dir>/transcript.sh <transcript>`; read subagent transcripts listed under `[subagents]` where the work happened (in `/build-from-spec`, the implementer and reviewer subagents).
- "What counts as a problem", "Not a finding", and "Which skill gets the blame" — carried over from the spec's sections of the same names, including the sound-reason rule for "Rulings I made" and the third-party rule. A deliberate override by the user is raised as a finding titled as the user's choice, for them to judge — never treated as a skill bug on its own.
- Output: either `No findings.` plus 1–2 lines why, or one block per finding:
  ```
  ### F<n>: <title in general terms>
  - What happened: <where in the transcript (file, quoted line)>, in general terms
  - Skill says: `<skill>/SKILL.md` <step> — "<quote>", or "nothing covers this"
  - Blame: `<skill>` — <why this skill; say "upstream" when it is>
  - Fix kind: <one sentence, general terms>
  - Testable: yes — <what to replay> | no — <why>
  ```
- Privacy: titles, "What happened" and "Fix kind" use general terms, never the product's names, data or code.

- [ ] **Step 1: Write `reviewing-a-run.md`** to its contract, aiming each rule at a baseline failure recorded in `baseline-results.md`.
- [ ] **Step 2: Write `SKILL.md`** to its contract.
- [ ] **Step 3: Validate.** `bash scripts/validate-marketplace.sh` → all ✓, including `product-development: skill(s) present and named consistently`.
- [ ] **Step 4: Run all 8 scenarios, with-skill arm, 3 reps each.** Record in `green-results.md` per scenario: x/3 passing per "Pass if" item, with quotes for any failure.
- [ ] **Step 5: REFACTOR.** For each scenario below 3/3: name the new rationalisation, tighten the wording that let it through (a positive recipe for wrong-shaped output; a prohibition + table row for a skipped rule — see writing-skills "Match the Form to the Failure"), and re-run that scenario 3×. Repeat until all 8 are 3/3. Record each round in `green-results.md`.
- [ ] **Step 6: Commit.**
```bash
git add product-development/skills/improve-workflow/ docs/superpowers/tests/improve-workflow/green-results.md
git commit -m "Add improve-workflow skill to product-development"
```

---

### Task 4: Docs

**Files:**
- Modify: `README.md` (skills table: new `product-development` row after `build-from-spec`; the plugin summary paragraph under the table)
- Modify: `CLAUDE.md` (`product-development` bullet in "Architecture"; "Cross-marketplace dependency" paragraph)
- Modify: `product-development/.claude-plugin/plugin.json` (`description`, `keywords`)
- Modify: `.claude-plugin/marketplace.json` (`product-development` entry `description`, kept identical to `plugin.json`'s)

- [ ] **Step 1: README row.** Problem: workflow skills only get better when someone notices a failure and remembers to fix it. How to use: run `/improve-workflow` at the end of a `/create-prd`, `/create-spec` or `/build-from-spec` session; a fresh subagent reviews the run; you pick which findings to pursue; each fix is tested with `superpowers:writing-skills`, or marked untested when no faithful test exists; you approve the diff; it opens a PR on your skills checkout and stops. "No change needed" is the usual result. Only you can start it. Needs a local checkout of this marketplace you can push to, `superpowers` (installs as a dependency) and the `gh` CLI, signed in. Add "reviews each run to improve the workflow skills" to the summary paragraph.
- [ ] **Step 2: CLAUDE.md.** Append one sentence to the `product-development` bullet describing `improve-workflow` (manual-only via `disable-model-invocation`). Add `improve-workflow` calls `superpowers:writing-skills` to the dependency paragraph.
- [ ] **Step 3: Manifests.** Add one sentence to both descriptions ("Review a finished workflow run and fix the skill that let it go wrong, test-first, as a PR."); add keywords `continuous-improvement`, `skill-improvement`, `retrospective` to `plugin.json`.
- [ ] **Step 4: Validate.** `bash scripts/validate-marketplace.sh` → all ✓. `jq -r '.description' product-development/.claude-plugin/plugin.json` equals `jq -r '.plugins[] | select(.name=="product-development") | .description' .claude-plugin/marketplace.json`.
- [ ] **Step 5: Commit.**
```bash
git add README.md CLAUDE.md product-development/.claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -m "Document improve-workflow"
```
