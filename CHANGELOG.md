## 2026-09-16 — Configurable movie-selection wait (prepared)

MOVIE_SELECTION_WAIT_SECONDS defaults to1800; testing may set60. Movie waits
poll every5seconds against a monotonic deadline, reject invalid values and stop
without ripping at timeout. TV waits and MANUAL_WAIT_TIME remain unchanged.
The setting is captured at job startup and cannot shorten an active old worker.
Four timeout regressions pass; independent replay passes45 B70 tests and40
product tests, including22 focused selection tests. No live installation or
processing is claimed. Apply0004 after0003; arm-cp owns deployment and rollback.

## 2026-09-16 — Manual selection UI correction (prepared)

Movie fallback set waiting without manual_mode, leaving job-detail controls
disabled. The additive [patch](patches/arm/0003-manual-selection-ui.patch) sets
that flag and exposes controls for existing non-series waiting jobs. Submitted,
active and terminal jobs remain disabled; TV behavior, authentication and CSRF
are unchanged. Three form-level regressions supplement the routing assertion.
41 B70 source tests pass, including18 focused selection tests. Source tests do
not establish installation or live extraction. arm-cp owns the workload upgrade;
retain the prior image for rollback and all job/media records.

# Changelog

## 2026-09-16 — Movie-selection source repair verified, not deployed

A small MakeMKV selector supports explicit attribute49 identification, opt-in
chapter/size heuristics, and manual title IDs bound to an ARM job and inventory.
Default fallback is existing operator selection; series routing is unchanged.
The sanitized 139-title regression selects title32 / playlist00609.mpls via the
unique FPL_MainFeature attribute; legacy heuristics select128. This is retained
inventory evidence, not fresh disc binding or successful extraction.

Independent replay passed33 product tests and38 B70 application-source tests,
including15 focused policy/parser/routing regressions. No rip, runtime update,
image build or privilege change occurred. B70 workload pins remain with arm-cp;
source publication does not install this repair. See [movie selection](docs/movie-selection.md)
for configuration, limitations and rollback. Older entries below are historical.

## 2026-09-11 — Source import and deployment handoff

- Imported the complete reliability patch series, its 18 tests, upstream license, and detailed review/change inventory.
- Verified exact source-tree replay, passing tests, compilation, shell syntax, and whitespace checks.
- Made a custom image an explicit deployment prerequisite; removed the implicit stock-image selection from Compose.
- Added a ChatGPT Work handoff covering the fastest dashboard/login milestone, Docker/sudo prerequisites, SATA mapping, storage, encrypted secrets, live acceptance, and rollback.
- No custom image was built and no runtime or source media was changed.

## 2026-09-11 — Docker preparation

- Selected digest-pinned stock ARM 2.24.3 with Compose, superseding the custom-image proposal.
- Prepared dedicated local state and work-media directories and complete ripping-only runtime configuration.
- Installed user-local SOPS/age, generated an age identity outside Git, and encrypted planned login YAML with successful decrypt/SHA-256 round-trip.
- Documented exact filesystem layout, ownership, packages, dashboard access, secrets recovery, acceptance, and rollback.
- Passed Compose validation and the existing appliance/VA-API production baseline.
- Docker installation remains blocked on local sudo authentication; planned credentials are not applied. New SATA drive mapping and live acceptance remain pending.

## 2026-09-11

- Established Helix ARM application documentation and ripping-only example configuration.
- Documented deployment, preservation, acceptance, rollback, and staged reliability changes.
- Recorded the operator-reported SATA controller move with guest verification pending.
- No runtime installation or live application acceptance performed.
