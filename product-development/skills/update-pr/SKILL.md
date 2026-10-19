---
name: update-pr
description: Use when the user runs /update-pr with a GitHub PR number or URL and wants that PR's title and description rewritten so a reader with no context understands them.
argument-hint: "<PR number or URL>"
---

# Update PR

Rewrite the title and body of PR `$ARGUMENTS`, then save them to GitHub.

The user typed `/update-pr`, so they want the PR changed. That is the go-ahead to run `gh pr edit`. Do not ask again.

## The writing rule

This is the rule from `/mattpocock-skills:wait-what`, copied here by the user. Do not call that skill with the Skill tool: it is user-only and the call fails. Apply the rule below yourself.

1. **Start with a tl;dr.** The body starts with `## tl;dr`: 1–2 sentences that say what changes for the end user and why it matters to them. A reader who has not seen the branch must understand them. If the current body does not say why it matters, take it from the linked spec. If there is no spec, take it from the code.
2. **Write in ASD-STE100 Simplified Technical English:**
   - One idea per sentence. At most 20 words for an instruction, 25 for a description.
   - Active voice. Simple present, past or future tense.
   - Common words, each with one meaning. Use the same word for the same thing every time.
   - Keep "a" and "the". Put at most 3 nouns in a row.
3. **Use the repo's own words.** Read `CONTEXT.md` at the repo root if it exists. Use its terms. Never use a word from its _Avoid_ lists. If an _Avoid_ entry states a limit (for example, "when referring to the process"), avoid the word only within that limit. Code names (for example, `PortfolioSearch`) stay as they are, even when the plain word is on an _Avoid_ list.
4. **Explain terms a new reader may not know.** Use a short phrase taken from the spec or the code. Explain at most 5 terms. Pick the terms that the tl;dr and `## What changes` depend on.

## Steps

1. If `$ARGUMENTS` is empty, ask for the PR number or URL, then stop.
2. Read the PR:
   - `gh pr view $ARGUMENTS --json number,url,title,body,state,baseRefName,headRefName,commits,files`
   - Save `gh pr diff $ARGUMENTS` to a file and count its lines. If it has more than 1,000 lines, read only the code files in it. Skip tests, test data, plans and specs. You may still read the spec file for rule 1.
   - If `state` is `MERGED`, rewrite the PR anyway. Keep pending items (unticked boxes, deploy steps) as they are.
3. Read `CONTEXT.md` (see rule 3).
4. Write the title and body in the shape below. Save the body to a temp file.
5. `gh pr edit $ARGUMENTS --title '<title>' --body-file <temp file>`. Put the title in single quotes. Write each `'` in the title as `'\''`.
6. `gh pr view $ARGUMENTS --json title,url` to confirm the change. Give the user the URL and the new title.

## Output shape

**Title:** `<Area or feature>: <what changes, in plain words>`. At most 70 characters. No `feat(x):` prefix. Example: `Ask Muse: a progress list while a question runs`. The area is the product area a reader knows (for example, `Ask Muse` or `Docs/Slides add-on`). It does not have to be an Area in `CONTEXT.md`.

**Body**: a new description of the PR and its code, written as if it were the first one. In this order:

1. `## tl;dr`: 1–2 sentences (rule 1).
2. `## What changes`: one bullet per change. Start each bullet with a bold sentence that says the change; add detail after it.
3. Every other section in the current body (spec and plan links, deviations, known limits, deploy order, follow-ups, merge notes), rewritten in STE. Leave out the test results and the test plan. Keep every other fact, number, path and link. The code is the source of truth. "The code" means the code at the PR's head commit, including files the diff does not change. If a fact in the current body differs from the code in any way, however small, write what the code does.
   - Spec, plan and linked-PR lines that have no heading go under `## Spec and plan`.
   - Technical sections (for example, one section per app) stay as their own sections, after "What changes".
   - Other text with no heading stays next to the section it is about. If it is about no section, put it at the end of `## What changes`.
4. `## Checks still to run`, only if the current body has unticked manual checks. Keep each box unticked.
5. The footer line (for example, "🤖 Generated with Claude Code"), if the current body has one.

## Common mistakes

| Mistake | Fix |
|---|---|
| Calling `Skill("mattpocock-skills:wait-what")`, then stopping when it fails | The rule is above. Apply it. |
| Asking "should I overwrite the current body?" | `/update-pr` is the request. GitHub keeps the old body in the edit history. |
| Dropping a fact from the current body ("please squash-merge", a follow-up) | A rewrite changes the words, not the facts. Only the code can change a fact. |
| Long sentences joined with "and", "which" or semicolons | Split them. One idea per sentence. |
