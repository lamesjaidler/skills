---
name: apply-laws-of-ux
description: Use when the user wants a UI critiqued, reviewed, audited, or improved against the Laws of UX (lawsofux.com), from a screenshot, code, live URL, or description; or wants a new page, screen, or flow prototyped using the Laws of UX; or names laws like Hick's, Fitts's, Jakob's, Miller's, Gestalt proximity, or the Peak-End Rule.
---

# Laws of UX

The 30 laws on [lawsofux.com](https://lawsofux.com/) are the lens for two jobs: **critique** an existing UI, or **prototype** a new one. Before either, read [laws.md](laws.md) (in this skill's directory) in full. It groups the laws into seven lenses, with what a breach looks like and what to do about it.

Pick the mode from the request:
- An existing UI is given (screenshot, code, URL, or a description of a current screen) → **Critique**.
- A new UI is wanted → **Prototype**.

## Critique

1. **Get the UI.**
   - Screenshot: read the image.
   - Code in the repo: read the page and the CSS and JS it uses.
   - Live URL: open it with browser tools if you have them. If not, ask for a screenshot.
   - Description: work from the words.

2. **Sweep all seven lenses.** For every law in laws.md, ask its *Look for* question of this UI. Cite the law whose *Look for* matches the breach.

3. **Write the reply.** It has exactly these parts, in this order:
   1. **Limits:** one line on what this input can't show (e.g. a screenshot shows no loading states, errors, or later steps).
   2. **Findings,** numbered, most severe first. BLOCKER and MAJOR findings take three lines each, like this:

      **2. MAJOR · Fitts's Law · `JoinCard.tsx:31`**
      Problem: the "Join call" button is 20px tall on mobile, so taps miss it.
      Change: make it full width and 48px tall, pinned to the bottom of the screen.

      MINOR findings take one line each: **9. MINOR · Law · location**: the change.
      - **Severity:** `BLOCKER` (users can't finish, lose data, or pay wrongly), `MAJOR` (slows, confuses, or drives users off), `MINOR` (polish).
      - **Law:** one per finding, the one whose *Look for* matches best.
      - **Location:** `file:line` for code; the screen region for a screenshot; the element for a URL; the step for a description.
   3. **Not a UX law, but broken:** bugs no law explains, one line each. Leave this part out if there are none.
   4. **The two hand-off questions** from step 4.

4. **Hand off.** Ask two questions, and do nothing else until they're answered. Use AskUserQuestion if you have it (both questions in one call); otherwise ask in prose.
   - **Which findings?** All, BLOCKERs only, BLOCKERs and MAJORs, or numbers the user lists.
   - **How?** If the UI is code in the repo: *prototype first* (variants of the page to compare before changing it) or *edit the code directly*. If it isn't: *prototype it* or *stop here*.

   Skip a question only when the user's message already answers it in words: it names which findings ("all", "1 and 3") or the route ("prototype", "edit the code"). "Improve it", "fix it", or "make it better" names neither.

5. **Act on the answer.**
   - **Edit the code directly:** make exactly the chosen changes, then report per finding what changed (`file:line`). If a change needs a product decision the finding doesn't settle (drop a payment method, remove a promo), ask before making it.
   - **Prototype:** go to Prototype below. The chosen findings are the brief, and the variants go on the existing page.

## Prototype

1. **Load the prototype skill.** Call the Skill tool with `mattpocock-skills:prototype` and follow its UI branch. If the Skill tool can't find it, tell the user to install the `mattpocock-skills` plugin from `claude-plugins-official`, then stop.
2. **Add the law lens** to that skill's steps:
   - **Variants:** make each variant a different answer to a trade-off between laws that matters for this UI, e.g. Hick's Law (one main action) against Pareto (the top three actions all visible). Name the trade-off in the one-line plan.
   - **Trace:** every design choice in a variant names the law behind it, per variant, in the switcher's info panel or a top-of-file comment.
   - **From a critique:** every variant fixes every chosen finding. List the finding numbers each variant covers.
   - **Check before hand-off:** sweep each variant with the seven lenses and fix any breach you find.
3. **Hand off** as the prototype skill says, plus a table: variant · trade-off it takes · laws it leans on.

## Common mistakes

| Mistake | Fix |
|---|---|
| Fixing everything because the user said "improve it" | Findings first, then the two hand-off questions. "Improve" doesn't pick findings or a route. |
| Deciding product questions while editing (removing payment methods, dropping a promo) | Ask; it's the user's call. |
| Grouping several laws into one themed finding | One law per finding, so each change traces to one law. |
| Citing a law from memory | Match the breach to a *Look for* line in laws.md (e.g. autofill off is Parkinson's Law; a key item mid-list is the Serial Position Effect). |
