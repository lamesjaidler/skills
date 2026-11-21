# Grilling transcript: Shiftswap (fictional)

Steps 1–3 of `create-raw-prd` are done. This is the full grilling. **Q** is the agent,
**A** is the user (Dana, Head of Operations at Brew & Bite, a café chain).

**Q: What's the idea, in one line?**
A: A way for our hourly staff to swap shifts with each other properly, instead of the
WhatsApp mess we have now.

**Q: What goes wrong with WhatsApp today?**
A: Every café has a staff WhatsApp group. Someone posts "can anyone take my Saturday
open?", someone says yes, and that's the swap. The manager often finds out on the day. Or
doesn't find out at all, and the rota on the wall is wrong. Two weeks ago in the Leeds
Headrow café nobody turned up to open on a Saturday because both people thought the other
one had it. We opened 90 minutes late and lost the whole breakfast rush.

**Q: How often does a swap go wrong like that?**
A: We count "uncovered shifts": a shift where nobody turned up, or we ran a person short.
Across the chain it's about 9 a month that trace back to a swap.

**Q: How many swaps happen in total?**
A: I asked the managers to count for a fortnight. Roughly 60 swap requests a week across
all 14 cafés.

**Q: Who is affected besides the staff?**
A: Store managers, mainly. They each spend about 3 hours a week fixing the rota after
swaps. And payroll. Our payroll admin, Mei, makes about 12 corrections a month because the
rota doesn't match who really worked.

**Q: Why fix this now and not last year?**
A: The audit. In September two cafés failed a working-hours audit. In both cases an
under-18 worked past 10pm, and both came from a swap the manager never saw. If we fail
again the fine is serious, and frankly it's just wrong.

**Q: Who are the users? Give me numbers.**
A: About 210 hourly staff. They offer shifts and take shifts. 14 store managers, one per
café, who approve swaps. 2 area managers who want to see what's going on across their
cafés. And Mei in payroll, just her.

**Q: Do the area managers approve anything?**
A: No. They only look. They want to see which cafés have lots of swaps, because that
usually means the rota was bad to begin with.

**Q: What does Mei need?**
A: One list a week of every approved swap, so she pays the person who worked. Today she
rebuilds it from manager emails.

**Q: What does success look like? Start with the main number.**
A: Uncovered shifts from swaps. 9 a month now. I want 2 or fewer.

**Q: By when?**
A: Three months after launch.

**Q: Other measures?**
A: Manager time on rota fixes: 3 hours a week down to 1. Payroll corrections: 12 a month
down to 3 or fewer. And zero working-hours breaches caused by a swap. That one is not
negotiable.

**Q: How will you know staff use it rather than WhatsApp?**
A: Good question. I'd want 80% of swaps going through it within 8 weeks. I can measure
that because managers will still see who really worked.

**Q: Is there a target for area managers using their view?**
A: I haven't thought about it. Leave that one. I'll ask Priya, she's the Ops Director and
they report to her.

**Q: Walk me through a swap as you want it to work.**
A: A staff member offers a shift they can't work. Colleagues who are allowed to take it
get told. One of them accepts. The manager approves or declines. Everyone involved is
told the result. The rota is right.

**Q: "Allowed to take it" — what are the rules?**
A: Four. Under-18s can't work past 10pm. Nobody goes over 48 hours in a week. Everyone
gets 11 hours rest between shifts. And you have to be trained for the role: a barista
can't cover a kitchen shift, and an opening shift needs a keyholder.

**Q: What happens when a swap breaks a rule?**
A: It must not be possible. The person who can't legally take it shouldn't even be
offered it. I don't want managers having to catch it.

**Q: Can a manager override a rule?**
A: No. Never. That's how we failed the audit.

**Q: How late can a swap be made?**
A: Up to 12 hours before the shift starts. After that it's too late, they ring the
manager like they do for sickness.

**Q: So sickness cover is out?**
A: Out. Sickness goes through HR's absence process and I don't want to mix the two. HR
would have my head.

**Q: What if nobody accepts the offer?**
A: Then the shift stays with the person who offered it. They need to be told clearly that
it's still theirs. That's half the problem today, people think posting in the group means
they're off the hook.

**Q: How fast must a manager decide?**
A: I'd say within 4 hours. I think they will, but I haven't asked them.

**Q: And when the manager doesn't respond?**
A: Hmm. Some managers want it to just auto-approve if the rules pass. I can see the
appeal but I'm nervous. That's Priya's call. Park it.

**Q: Can staff swap with someone at another café?**
A: No, not in v1. Contracts are per site and pay rates differ between cafés. It would
turn into a payroll project.

**Q: Could a member of staff just give a shift away without taking one back?**
A: Yes, that's most of them actually. "Swap" is the word we use but most are giveaways.
Both should work.

**Q: Does this replace your rota tool?**
A: No. Managers build the rota in the tool we already have and they like it. This only
handles changes after the rota is published. By the way, that rota tool has an API, so
you could just pull the shifts from there. And honestly a WhatsApp bot might be the
easiest thing, since everyone's already in there. Push notifications through Firebase or
something for the alerts.

**Q: Noted for the spec. What else is out of v1?**
A: Open shifts that managers post for anyone to grab. People have asked, and it's a good
idea, but it's a different thing and I want swaps solid first. Holiday requests, also
HR's. And nothing that changes pay rates: you get your own rate whoever's shift it was.

**Q: Are agency staff included?**
A: We use agency staff at Christmas. I don't know if they should be in this. Ask Tom, the
HR lead.

**Q: What does the staff member see after they offer a shift?**
A: Where it's at. Offered, someone's accepted, waiting for the manager, approved,
declined. They shouldn't have to chase.

**Q: Does the auditor need anything?**
A: Yes. For every swap: who offered, who took it, who approved, and when. Kept for two
years. If the auditor asks, I want to hand it over the same day.

**Q: Do all staff have a smartphone?**
A: I assume so. They're all in the WhatsApp groups. I haven't checked the kitchen
porters.

**Q: What could make this fail?**
A: Staff keep using WhatsApp because it's quicker. That's the big one. Second, managers
approve everything without looking, and we're back where we started, just with a paper
trail. Third, the union rep at the Manchester cafés has been touchy about anything that
tracks hours, so we should talk to her early.

**Q: What would you do about staff staying on WhatsApp?**
A: Managers stop honouring WhatsApp swaps from launch day. If it isn't in the tool, it
didn't happen and it's still your shift.

**Q: One open point: is a split shift where half is covered "uncovered"?**
A: I don't know how we count those. Mei would know.

**Q: Have we reached a shared understanding? I'll write the PRD to `docs/prd/shiftswap.md`.**
A: Yes. Go.
