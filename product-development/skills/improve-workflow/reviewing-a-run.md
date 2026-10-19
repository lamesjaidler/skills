# Reviewing a workflow run

You review one finished run of `/create-prd`, `/create-spec` or `/build-from-spec` and find where a skill let the agent go wrong, so the skill can be fixed. "No findings" is the usual answer.

## Reading the run

- `bash <this folder>/transcript.sh <transcript.jsonl>` prints the session as text. Its last section, `[subagents]`, lists each subagent's transcript and what it did. Run the script on the ones where the work happened: in `/build-from-spec`, the implementers and reviewers.
- Read the run's files (PRD, spec, plan, diff) and the skills as they ran.

## What a finding is

A finding is one of these, shown by a quoted line from the transcript or a `file:line` in the run's files:

1. **Skipped step.** The agent skipped, reordered or changed a step the skill sets out, and gave no reason.
2. **Skill led it wrong.** The agent followed the skill, and the skill's wording led to a bad result: an instruction read two ways, a missing step, a subagent prompt that left something out.
3. **Output doesn't match input.** The build differs from the spec, the spec drops or contradicts a PRD line, or the plan misses part of the spec, and no reason was given.
4. **User stepped in.** The user had to correct the agent or repeat themselves.
5. **User overrode the skill.** The user deliberately chose differently from what the skill says. Title it as the user's choice; the user judges whether the skill's default should change.

If the run shows none of these, the answer is `No findings.` A finding needs evidence in the run. Don't infer a problem the run doesn't show.

## Not a finding

- **A departure or ruling with a reason given at the time, where the reason holds against the spec** (or PRD): nothing in it says otherwise. This holds even if you would have asked the user instead, and even if the user never said OK to it. A ruling with no reason, or one the spec contradicts, is a finding.
- The user changing their mind.
- One-off environment failures: network, a tool crashing, auth.

## Which skill gets the blame

Blame the skill where the problem first entered:

- **A step in this run went wrong:** the skill that ran that step. That's `/create-prd`, `/create-spec`, `/build-from-spec`, or a `product-development` skill they call: `create-raw-prd`, `critique-prd`, `stop-and-think`, `apply-laws-of-ux`, `critique-spec`, `critique-implementation-plan`, `update-pr`.
- **An input file left something undecided, vague or wrong** (a spec term with no rule behind it, a PRD gap): the skill that wrote and checked that file. That's `create-spec` and `critique-spec` for a spec; `create-prd`, `create-raw-prd` and `critique-prd` for a PRD. Blame it even though its session isn't in this transcript: the file is the evidence. A later skill that also missed the gap can be a second finding.
- **The root cause is in a skill from another plugin** (`superpowers`, `mattpocock-skills`): the `product-development` skill that calls it. The fix goes in its dispatch prompt or the step that wraps it.

## Output

Either `No findings.` and one or two lines on why, or one block per finding:

```
### F<n>: <title in general terms>
- Kind: <1–5 from "What a finding is">
- What happened: <transcript quote or file:line>, in general terms
- Skill says: `<skill>/SKILL.md` <step> — "<quote>", or "nothing covers this"
- Blame: `<skill>` — <why this skill; say "upstream" when the gap came from an earlier session's file>
- Fix kind: <one sentence, general terms: the smallest change, tightening an existing line before adding one>
- Testable: yes — <what to replay: a subagent's exact dispatch prompt, or the conversation up to one turn> | no — <why: it built up over many turns or a long run>
```

`Testable: no` is only for a problem that built up across many turns or tasks. A slip in one turn or one subagent is `yes`, however late in the run it came: replay the conversation up to that turn, or that subagent's exact prompt.

The skills repo is public. Write titles, "What happened" and "Fix kind" in general terms: never the product's names, data, file paths or code.
