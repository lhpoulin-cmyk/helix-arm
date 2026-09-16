# MakeMKV movie selection

For MakeMKV title extraction (`RIPMETHOD: mkv`, also DVD extraction), non-series
jobs pass through `arm/ripper/movie_selection.py`. The selector is pure: it takes
the parsed inventory, YAML policy, job ID and video type and returns a decision.
It never opens a disc. `TrackInfoProcessor` separately parses the inventory.

## Configuration in arm.yaml

Use the existing flat uppercase YAML configuration keys:

```yaml
MOVIE_SELECTION_STRATEGY: explicit
MOVIE_SELECTION_FALLBACK: manual
MOVIE_SELECTION_MANUAL_JOB_ID: -1
MOVIE_SELECTION_MANUAL_INVENTORY_SHA256: ""
MOVIE_SELECTION_MANUAL_TITLE_ID: -1
```

- `explicit` prefers exactly one MakeMKV `TINFO:<id>,49,0,"FPL_MainFeature"`
  attribute. Filenames, title names, duration, size and chapter count do not
  establish explicit identification. Conflicting attribute values or multiple
  marked titles invoke the fallback.
- `heuristic` opts into the old ARM order: chapter count descending, byte size
  descending, then numeric source title ID ascending. This is a heuristic, not
  verified identification. It can be selected directly or as the fallback.
- `manual` accepts an exact title ID only when BOTH the configured ARM job ID
  and inventory SHA-256 match the current attempt. Set all three override keys
  using a current `MOVIE_SELECTION` log entry. A stale or partial override
  requires operator input and cannot silently select on the next job/disc.
  Zero is a valid title ID; -1 means unset. The inventory hash binds normalized
  parser records, not a physical disc identity or historical provenance claim.

Fallback supports `manual` (default) or an explicitly opted-in `heuristic`.
With no valid manual override, ARM clears stale selections/start flags and uses
its existing waiting state and track-selection UI. Choose exactly one current
track and start that job within the existing 30-minute wait. Missing/multiple
choices or timeout stop before ripping; there is no silent heuristic fallback.
An explicit drive manual mode selects the manual strategy. Invalid policies,
incomplete inventories, and unknown video type cannot automatically select.
Unknown video type requires current-job operator selection or corrected movie
classification; an explicit playlist marker alone does not classify the disc.

Policy is loaded from the normal per-process `arm.yaml` (`ARM_CONFIG_FILE` when
set); start a new job with the intended snapshot. These keys require no database
migration and are not new web configuration controls. Every decision logs
`MOVIE_SELECTION` JSON with configured strategy/fallback, actual policy, reason,
job ID, inventory hash, title ID and candidates. Logs are private evidence and
may contain filenames. Waiting and final operator decisions are both recorded.

For MakeMKV movies this policy replaces the `MAINFEATURE` chapter/size shortcut,
including when `MAINFEATURE` is false. Changing `MAINFEATURE` alone is not this
repair. Existing series routing (auto/manual, length filters and existing
MAINFEATURE behavior) is unchanged. TV episodes and short titles are not mapped
or pruned by this selector. Blu-ray backup and HandBrake paths are unchanged.

## Verification and limits

`python3 -B -m unittest discover -s test/local -v` includes the pinned parser,
selector and routing tests without importing a live app or starting a rip.
The sanitized 139-title fixture uses all durations from a retained diagnostic
and matching attribute records from the earlier ARM job log. Its movie name is
replaced with MOVIE; it contains no raw logs or appliance identity. Attribute49
marks title32 alone: playlist00609.mpls,6161seconds,16chapters,27350710272bytes.
The legacy heuristic selects title128. This proves policy behavior on retained
evidence, not a fresh optical binding or actual extraction success.

Deploy only through the workload owner's reviewed source/image release. No
runtime changes, disc reads or rip acceptance accompany source tests. Restore
the previous matched image/configuration to roll back; retain all logs/media.

## Product delivery

The implementation and 15 focused tests are in
[0002-movie-selection.patch](../patches/arm/0002-movie-selection.patch).
[The manifest](../patches/arm/movie-selection.json) pins the patch checksum and
both replay trees. Apply after the existing reliability patch. On B70, apply
after its existing application-secret patch as well; do not remove that patch.
Both combinations were independently replayed: 33 product tests and 38 B70
source tests pass. The unchanged upstream and dependency pins remain in force.

This is a prepared product source release, not an installed image. B70's active
arm-cp source lock and root-owned executor remain unchanged. Image build,
workload pin adoption and live qualification are separate controlled steps.
The protected executor has no authority to load this patch from a writable
checkout. Do not bypass that boundary or rerip to test selection.
