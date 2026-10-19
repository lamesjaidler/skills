# Spec: home screen

## Goal
Running `jotter` with no arguments gives a useful starting point instead of the help text.

## Behaviour
- `jotter` with no arguments shows the home screen.
- Home shows recent notes, one title per line.
- Below them, one line: `jotter new` to start a note.

## Constraints
- No new dependencies.
- Plain text output; no colours.

## Tests
- Home lists recent notes.
- Home ends with the `jotter new` hint.
