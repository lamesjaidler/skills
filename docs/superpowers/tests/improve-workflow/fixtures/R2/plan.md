# List command Implementation Plan (excerpt)

### Task 3: list_notes and the list command

**Files:**
- Modify: `jotter/notes.py`
- Modify: `jotter/cli.py`
- Test: `tests/test_list.py`

- [ ] **Step 1: Write the failing tests** — `test_empty_store_prints_no_notes`, `test_list_newest_first` (three notes with `edited_at` 1, 3, 2 → titles printed in order 3, 2, 1).
- [ ] **Step 2: Run them — expect FAIL.**
- [ ] **Step 3: Implement `list_notes(store) -> list[Note]`** returning notes sorted by `edited_at`, descending. `jotter list` prints each title, or `No notes yet.`
- [ ] **Step 4: Run tests — expect PASS.**
- [ ] **Step 5: Commit.**
