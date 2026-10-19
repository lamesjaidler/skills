---
name: summarise
description: Use when the user runs /summarise, or asks for a summary of a PRD, spec, design doc or implementation plan — "summarise this spec", "what did the plan decide?", "key decisions in this PRD" — usually before they approve it; or, after an agent has carried out an implementation plan, asks what was actually done — "summarise the work", "what changed from the plan?"; or asks for either in ASD-STE100 or Simplified Technical English.
argument-hint: "[path to a PRD, spec or plan, or to a plan already carried out]"
---

# Summarise

Summarise one PRD, spec or implementation plan for the user, who reads the summary before they approve the doc. If an agent has already carried out the plan, summarise the work instead, for the user to read before they accept it. A summary is **what the doc decided, or what the work did, and what it leaves open for the user**, in ASD-STE100 Simplified Technical English. It is not a shorter copy of the doc, and it is not a review.

## Steps

1. **Find the doc.** `$ARGUMENTS` is its path. If it is empty, use the PRD, spec or plan written or discussed most recently in this conversation. If there is none, ask for the path and stop.
2. **Read all of it.**
3. **Name its type** from the file name and headings. A **PRD** says what to build and why. A **spec** says how: design, architecture, data. A **plan** is an ordered list of tasks. An **implementation** is a plan that an agent has carried out: the conversation says so, or the repo has commits for its tasks. Plans often keep their checkboxes empty after the work, so check the commits. If you cannot tell, ask.
4. **For an implementation, read the work.** Find the base with `git merge-base HEAD <default branch>`. Read `git log <base>..HEAD` and `git diff --stat <base>..HEAD`. Read the diff of each file that is not in the plan or that differs from the plan's code. Use only commands that change nothing: no tests, builds or installs. If the plan and the commits disagree, report what the commits show.
5. **Pick the items** with the table below, or with the implementation section.
6. **Reply in the shape below.** Change no files.

## What to pick

A **decision** is a choice the doc makes where another choice was possible. Detail that only explains a decision goes inside that decision's sentence, or stays in the doc. **Needs you** holds only what the doc itself leaves open.

| Type | Decisions | Needs you |
|---|---|---|
| PRD | The problem, in one item. Why now, in one item. The target users, in one item. Each success metric and its target. Each non-goal. The requirements, one item per group of related ones. | Open questions. Metrics with no target. Assumptions nobody has checked. |
| Spec | Each design choice: stack, data model, storage, key rules, rejected options and why. What is out of scope. | Items the doc marks open, TBD, "tunable" or "revisit". Steps that are hard to undo. |
| Plan | The order of work, one item per phase or group of tasks. Each change from the spec. How "done" is checked. | Steps that are hard to undo: data migrations, deletes, deploys, history rewrites. Actions only the user can do: secrets, accounts, payments. |

A list of values (each badge, each price, each task) is one item. Name the group and point to it.

## Implementation

An implementation summary has three sections in place of **Decisions**:

- **Done:** what now exists, one item per phase or group of tasks.
- **Changed from the plan:** each place where the work differs from the plan. Compare the files the plan names with `git diff --name-only`. Compare the versions the plan names with the package manifest. Match each commit to its task. A commit that matches no task, for example a fix, is a change.
- **Not done:** each task with no commit, or with only part of its work.

**Needs you** holds the checks that the plan asks for and that no commit shows as done, for example a manual test. It also holds follow-ups, deploy steps and secrets that the plan or the commits name.

## Reply shape

```markdown
**<PRD | Spec | Plan>: <doc title>** · `<path>`
<One sentence: what the doc is for.>

**Decisions**
1. <one sentence, at most 25 words> (<pointer>)

**Needs you**
1. <one instruction, at most 20 words> (<pointer>)
```

For an implementation:

- The first line is `**Implementation: <plan title>** · branch <branch>`, and the sentence says what the work built.
- **Done**, **Changed from the plan** and **Not done** take the place of **Decisions**. Their items follow the same rules.
- The last line is: To review the code against the plan, run `mattpocock-skills:code-review`.

Rules for all types:

- Number the items. Keep the doc's order.
- A **pointer** is the doc's own ID (`R4`, `Q2`, `Task 8`). If there is none, use the section number (`§6`). If there is none, use the heading. For an implementation, add the commit: `(Task 8, a3b183a)`.
- If a section has no items, write "Nothing." under it.

Example, from a spec for a CSV export:

```markdown
**Decisions**
1. The export runs as a background job, not in the web request (§3).
2. S3 keeps each file for 7 days, then deletes it (§4).

**Needs you**
1. Decide the maximum number of rows for one export (§3, marked "TBD").
```

## Write in ASD-STE100

These are the main writing rules of ASD-STE100 Issue 9 (free from asd-ste100.org), in our own words. Do not use its dictionary. Use the simplest common word instead.

- **One meaning per word.** Use common words. Use the same word for the same thing every time.
- **Keep technical nouns and verbs.** Code names, paths, product names and the doc's own terms (`periodKey`, "grace window") stay as they are.
- **Verbs:** active voice. Simple present, past or future tense. No "-ing" verb forms. Use a verb for an action: "the app checks", not "the app does a check".
- **No phrasal verbs.** "Set up" becomes "make" or "configure". "Carry out" becomes "do".
- **Sentences:** one idea each. At most 25 words for a decision and 20 for an instruction. Write instructions in the imperative. Put a condition first: "If X, do Y."
- **Keep "a", "the" and "this".** Put at most 3 nouns in a row.
- **No semicolons and no contractions.**
- **Word count:** a code span, a number with its unit, and text in parentheses each count as one word.
