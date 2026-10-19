# Home screen Implementation Plan (excerpt)

### Task 1: Home view

**Files:**
- Create: `jotter/home.py`
- Modify: `jotter/cli.py`
- Test: `tests/test_home.py`

- [ ] **Step 1: Write the failing tests** — `test_home_lists_recent_notes`, `test_home_ends_with_new_hint`.
- [ ] **Step 2: Run them — expect FAIL.**
- [ ] **Step 3: Implement `render_home(store) -> str`** showing recent notes, one title per line, then the `jotter new` hint. `main([])` prints it.
- [ ] **Step 4: Run tests — expect PASS.**
- [ ] **Step 5: Commit.**
