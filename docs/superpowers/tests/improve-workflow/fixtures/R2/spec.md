# Spec: list command

## Goal
Users can see all their notes at a glance, most recently worked-on first.

## Behaviour
- `jotter list` prints one line per note: its title.
- Notes are sorted by last edited, newest first.
- With no notes, it prints `No notes yet.`

## Storage
Notes are read from `~/.jotter/notes/*.json` using `orjson` for speed.

## Constraints
- No new dependencies.

## Tests
- Empty store prints `No notes yet.`
- Three notes print in last-edited order, newest first.
