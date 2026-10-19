# Spec: note tags

## Goal
Users can tag notes and list notes by tag.

## Behaviour
- `jotter tag <note-id> <tag>` adds a tag to a note. Adding an existing tag is a no-op.
- `jotter list --tag <tag>` prints only notes with that tag, in the usual list order.
- Tags are case-insensitive: `Work` and `work` are the same tag.

## Storage
Tags are stored as a list on each note's JSON record, under `tags`.

## Constraints
- No new dependencies.
- Existing notes without `tags` load as having no tags.

## Tests
- Tagging twice keeps one tag.
- `--tag Work` matches a note tagged `work`.
- Old notes without `tags` still load.
