# Grilling transcript: Jotter pin (fictional)

Steps 1–3 of `create-raw-prd` are done. This is the full grilling. **Q** is the agent,
**A** is the user (Sam, who maintains Jotter, a notes CLI, alone).

**Q: What's the idea, in one line?**
A: Let people pin a note so it stays at the top of `jotter list`.

**Q: What goes wrong today?**
A: The list is newest-first. The two or three notes I open every day sink as I add new
ones, and I scroll for them each time.

**Q: How often?**
A: Every day, several times. I have about 300 notes.

**Q: Who else has this problem?**
A: Three users have asked for it in the issue tracker. I don't know how many users there
are in total.

**Q: What does success look like?**
A: I stop scrolling for my daily notes. I haven't set a number.

**Q: What is out of v1?**
A: Ordering the pinned notes by hand. Pinned ones can just be newest-first among
themselves. Hand-ordering is more work than the problem is worth.

**Q: Is there a limit on pinned notes?**
A: I don't know. Maybe. I'll decide later.

**Q: What could make this fail?**
A: People pin everything and the list is back where it started.

**Q: Have we reached a shared understanding? I'll write the PRD to `docs/prd/jotter-pin.md`.**
A: Yes.
