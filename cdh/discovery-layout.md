# Discovery State Layout

All continuous-discovery skills read and write state in the user's product repo under `discovery/`, by convention — no config file.

```
discovery/
  snapshots/YYYY-MM-DD-<participant>.md   # shared evidence pool, all outcomes harvest from it
  <outcome-slug>/                         # one dir per outcome; parallel trios supported
    outcome.md                            # outcome statement + metric + history
    experience-map.md                     # current customer experience
    ost.md                                # the living opportunity solution tree (source of truth)
    assumptions/<solution-slug>.md        # assumptions + 2x2 placement + test specs + results
    touchpoints/YYYY-MM-DD.md             # weekly ritual log: decisions, cycle moves
```

**Selecting the outcome dir:** if exactly one `<outcome-slug>/` dir exists, use it. If several exist and the user didn't specify, ask which outcome. If none exists, the defining-outcomes skill creates one.

**Snapshots are shared:** one interview yields opportunities for multiple trees. Snapshots live outside outcome dirs; each outcome's mapping skill harvests what is relevant to it.

**Evidence tags:** every opportunity and insight carries its source, e.g. `[evidence: 2026-08-01-jane.md]`. Non-interview evidence (sales calls, support tickets, app reviews) is welcome and tagged with its source the same way; interviews are the privileged, weekly-refreshed source.

**OST format:** `ost.md` is a markdown outline — git-diffable, the single source of truth. Mermaid may be rendered on demand as a view, never stored as source.

```markdown
# OST: <outcome statement — copied from outcome.md>

- Opportunity: <customer-framed need, customer's words> [evidence: <snapshot files>]
  - Opportunity: <narrower sub-need> [evidence: ...]
    - Solution: <idea> (status: candidate | testing | pruned | advanced)
      - Assumption tests: see assumptions/<solution-slug>.md
```

**Target marker:** once the trio confirms a target, `prioritizing-opportunities` appends ` <- TARGET` to that node's line and logs a dated entry under a `## Target history` section at the end of the file (appended if absent). Confirming a new target removes the marker from the prior one; the history entry for it stays — only one node ever carries the marker at a time. Both the marker and the full history persist across restructures — moving, merging, splitting, or renumbering nodes must carry them forward, never drop them silently.

Node rules: every node has exactly one parent; opportunities are needs/pain-points/desires in the customer's frame; solutions attach only under the opportunity they address; pruned solutions stay in the tree with `(status: pruned)` for the decision record.
