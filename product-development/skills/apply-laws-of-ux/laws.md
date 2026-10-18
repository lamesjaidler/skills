# The 30 Laws of UX

Source: [lawsofux.com](https://lawsofux.com/) (Jon Yablonski). Each law links to its page there. The 30 laws are grouped into seven lenses so a sweep can't skip any.

Each entry has three parts:
- **Means:** the law in one line.
- **Look for:** what a breach looks like in a real UI.
- **Do:** concrete design moves that apply it.

## 1. Grouping (Gestalt)

### [Law of Proximity](https://lawsofux.com/law-of-proximity/)
- **Means:** things near each other read as related.
- **Look for:** a label closer to the wrong field than its own; equal spacing between unrelated groups; a destructive button sitting next to a primary one.
- **Do:** keep the gap inside a group smaller than the gap between groups; put labels next to (or above) their inputs.

### [Law of Common Region](https://lawsofux.com/law-of-common-region/)
- **Means:** things inside one bounded area read as a group.
- **Look for:** related fields with no shared container; unrelated fields (e.g. billing and shipping) mixed in one region.
- **Do:** wrap each group in a card, fieldset, or background tint.

### [Law of Similarity](https://lawsofux.com/law-of-similarity/)
- **Means:** things that look alike read as alike, even when apart.
- **Look for:** links styled like body text; primary and secondary actions styled the same; same style used for things that behave differently.
- **Do:** give each kind of element one consistent style; make links and actions look clickable.

### [Law of Uniform Connectedness](https://lawsofux.com/law-of-uniform-connectedness/)
- **Means:** visually connected things (lines, frames, shared colour) read as more related than unconnected ones.
- **Look for:** steps of a flow with no visual connection; a control far from the thing it changes.
- **Do:** join related items with lines, connectors, frames, or a shared colour band (e.g. a stepper line).

### [Law of Prägnanz](https://lawsofux.com/law-of-pr%C3%A4gnanz/)
- **Means:** people read complex shapes as the simplest form they can.
- **Look for:** busy, ambiguous layouts; icons or charts that need decoding.
- **Do:** use simple shapes and clear alignment; cut visual noise.

## 2. Attention

### [Von Restorff Effect](https://lawsofux.com/von-restorff-effect/)
- **Means:** among similar items, the one that differs is noticed and remembered.
- **Look for:** the primary action styled like the others; several things all shouting at once (so nothing stands out).
- **Do:** make one key action or fact visually distinct per view. Use restraint so it doesn't look like an ad. Don't rely on colour alone; avoid motion that bothers motion-sensitive users.

### [Selective Attention](https://lawsofux.com/selective-attention/)
- **Means:** people filter out what seems unrelated to their goal.
- **Look for:** important information styled like an ad or banner (banner blindness); several things changing at once (change blindness).
- **Do:** style critical information as content, near the task it affects; change one thing at a time and signal the change.

### [Serial Position Effect](https://lawsofux.com/serial-position-effect/)
- **Means:** people remember the first and last items in a series best.
- **Look for:** key nav items or options buried in the middle of a list.
- **Do:** put key items at the start and end; put the least important in the middle.

### [Aesthetic-Usability Effect](https://lawsofux.com/aesthetic-usability-effect/)
- **Means:** people see attractive designs as easier to use, and forgive small problems in them.
- **Look for:** a dated or inconsistent look that lowers trust (worse on payment screens); or polish hiding real usability problems in testing.
- **Do:** fix visual consistency where trust matters; in tests, watch what users do, not what they say about the look.

## 3. Memory and mental load

### [Cognitive Load](https://lawsofux.com/cognitive-load/)
- **Means:** the mental effort a UI demands. Extraneous load (effort that doesn't help the task) is the part design controls.
- **Look for:** decoration, animation, or text that doesn't help the current task; several things competing for attention at once.
- **Do:** remove what doesn't serve the task; show only what the current step needs.

### [Working Memory](https://lawsofux.com/working-memory/)
- **Means:** people hold about 4–7 chunks for about 20–30 seconds.
- **Look for:** users must remember something from a previous screen (an earlier choice, a code, a price) to act on this one.
- **Do:** prefer recognition over recall: carry earlier choices forward, show summaries, mark visited links, offer comparison tables.

### [Miller's Law](https://lawsofux.com/millers-law/)
- **Means:** working memory holds about 7 ± 2 items.
- **Look for:** long unbroken strings (card numbers, codes, IDs); long ungrouped lists.
- **Do:** chunk content into groups. **Misuse warning:** the number 7 is not a cap; don't use it to justify cutting a menu to 7 items.

### [Chunking](https://lawsofux.com/chunking/)
- **Means:** breaking information into meaningful groups.
- **Look for:** walls of text; long forms with no sections; long numbers with no spacing.
- **Do:** split into labelled groups with clear hierarchy; format numbers in groups (`4242 4242 4242 4242`).

## 4. Choices

### [Hick's Law](https://lawsofux.com/hicks-law/)
- **Means:** decision time grows with the number and complexity of choices.
- **Look for:** many equal-weight options where the user must decide fast; no recommended or default option.
- **Do:** cut or group options; highlight a recommended default; split complex tasks into steps; reveal advanced options progressively. **Misuse warning:** don't simplify so far that choices become vague.

### [Choice Overload](https://lawsofux.com/choice-overload/)
- **Means:** too many options overwhelm people and worsen the experience.
- **Look for:** long lists of near-identical options with no way to compare them.
- **Do:** show fewer, clearly different options; support side-by-side comparison; add search or filters for big sets.

### [Pareto Principle](https://lawsofux.com/pareto-principle/)
- **Means:** about 80% of effects come from 20% of causes.
- **Look for:** rarely used options given the same prominence as the common ones.
- **Do:** make the few most-used paths and options the most prominent; tuck the rest behind "more".

### [Occam's Razor](https://lawsofux.com/occams-razor/)
- **Means:** prefer the option with the fewest assumptions; avoid needless complexity.
- **Look for:** elements that can be removed without losing function.
- **Do:** remove elements until removing more would break the task.

## 5. Expectations

### [Jakob's Law](https://lawsofux.com/jakobs-law/)
- **Means:** users spend most of their time on other products, so they expect yours to work the same way.
- **Look for:** standard things in non-standard places (cart, search, logo, account); non-standard input formats; custom controls for standard jobs.
- **Do:** follow common conventions for the pattern. When redesigning, consider letting users keep the old version for a while.

### [Mental Model](https://lawsofux.com/mental-model/)
- **Means:** people use what they believe about how a system works to predict it.
- **Look for:** labels, flows, or terms that match the company's internal model, not the user's; controls whose effect surprises.
- **Do:** match user expectations and words (from research); make the system's state and effects visible.

### [Paradox of the Active User](https://lawsofux.com/paradox-of-the-active-user/)
- **Means:** users don't read instructions; they start using the product at once.
- **Look for:** instructions placed up front (intro paragraphs, manuals, long onboarding) instead of where they're needed.
- **Do:** put guidance in context: inline hints, tooltips, examples next to the field.

### [Tesler's Law](https://lawsofux.com/teslers-law/)
- **Means:** every system has complexity that can't be removed, only moved. The system or the user must carry it.
- **Look for:** users doing work the system could do (looking up codes on another page, computing values, choosing what could be derived).
- **Do:** move that work into the system: derive, default, or look it up.

### [Postel's Law](https://lawsofux.com/postels-law/)
- **Means:** be liberal in what you accept, conservative in what you send.
- **Look for:** strict input formats (phone, card, date) that reject reasonable variants; vague errors ("Invalid input").
- **Do:** accept many formats and normalise them; give specific, helpful feedback; set clear limits.

## 6. Speed and effort

### [Fitts's Law](https://lawsofux.com/fittss-law/)
- **Means:** the time to hit a target depends on its size and distance.
- **Look for:** small click or tap targets; tiny gaps between targets; key actions far from where the user's attention or pointer is.
- **Do:** make touch targets at least 44×44 px (Apple's guideline; WCAG 2.2's floor is 24×24) and space them well; put key actions where they're easy to reach; keep destructive actions away from primary ones.

### [Doherty Threshold](https://lawsofux.com/doherty-threshold/)
- **Means:** productivity soars when the system responds within 400 ms.
- **Look for:** actions with no feedback within 400 ms; long waits with no progress shown; buttons that can be pressed twice during a wait.
- **Do:** give feedback within 400 ms; show progress or skeletons for longer waits; use optimistic UI where safe.

### [Parkinson's Law](https://lawsofux.com/parkinsons-law/)
- **Means:** a task expands to fill the time available.
- **Look for:** tasks that take longer than users expect; autofill turned off; data typed in that the system already has.
- **Do:** cut the time to finish: autofill, saved details, smart defaults.

### [Flow](https://lawsofux.com/flow/)
- **Means:** a state of full, energised focus on a task.
- **Look for:** needless interruptions, unclear feedback, steps that are too hard or too easy for the user's skill.
- **Do:** match challenge to skill; give clear feedback; remove friction that breaks focus.

## 7. Motivation and feeling

### [Goal-Gradient Effect](https://lawsofux.com/goal-gradient-effect/)
- **Means:** people try harder as they get closer to a goal.
- **Look for:** multi-step flows with no sign of progress.
- **Do:** show clear progress (stepper, "step 2 of 4"); give a head start where honest.

### [Zeigarnik Effect](https://lawsofux.com/zeigarnik-effect/)
- **Means:** people remember unfinished tasks better than finished ones.
- **Look for:** hidden incomplete states; no cue that more content or steps exist.
- **Do:** show what's left (progress, checklists); signal that more content exists.

### [Peak-End Rule](https://lawsofux.com/peak-end-rule/)
- **Means:** people judge an experience mostly by its most intense moment and its end.
- **Look for:** a bare or confusing end state (confirmation, success, error); a painful peak (failed payment, lost data).
- **Do:** design the end moment with care: clear summary, next steps, a touch of delight; soften the worst moment.

### [Cognitive Bias](https://lawsofux.com/cognitive-bias/)
- **Means:** systematic errors in thinking that shape perception and decisions.
- **Look for:** defaults, framing, or urgency that push users against their interest (dark patterns); designers' own biases (confirmation bias) in how a UI was judged.
- **Do:** use defaults and framing honestly; check findings against evidence, not belief.
