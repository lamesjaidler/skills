# PRD: Jotter

## Problem
Developers lose quick thoughts (commands, TODOs, links) because opening a notes app breaks
their flow. They want to jot from the terminal they're already in.

## Users
- Solo developers who work mostly in the terminal (primary).

## Goals
- Capture a note in under 5 seconds without leaving the terminal.
- Find a note again in under 10 seconds.

## Non-goals
- Rich text, images, sharing.

## Requirements
- R1: `jotter new` opens a note for typing and saves on exit.
- R2: `jotter list` shows all notes.
- R3: Notes sync across the user's own machines.
- R4: `jotter find <text>` searches note text.

## Open questions
- Q1: How often does sync need to happen to feel instant?

Build ideas parked for the spec: SQLite storage; REST sync API.
