# Live trial acceptance

All items below are pending unless explicitly recorded with retained evidence.

- Confirm physical SATA drive identity, controller visibility, block/SCSI access, exact mounts, storage capacity, and permissions.
- Confirm image/source revision, ARM and MakeMKV versions, full configuration, persistent logs/database, and usable dashboard.
- Rip representative DVD and Blu-ray media in ripping-only mode. Record requested and actual title/output identity.
- Verify expected streams, audio/subtitle languages, chapters, metadata, and relevant HDR/color information against source inspection.
- Probe every output, perform full audio/video decode, and record SHA-256 and provenance. Nonempty files and exit zero alone are insufficient.
- Exercise missing output, destination collision, subprocess failure, interrupted jobs, restart recovery, and repeated disc insertion. Partial/failed output must never appear validated; retain complete diagnostics and source media.
- Verify dashboard log viewing, service/job/MakeMKV diagnostics, and retention after failures and restart.
- After runtime changes, regress explicit production VA-API av1_vaapi encoding: synthetic encode, output probe, full decode, checksum, and hardware-path/fallback checks. Record FFmpeg and driver versions.
- Record rollback readiness and operator assessment of reduced maintenance effort before adopting ARM as the replacement.

Keep raw evidence outside Git under `evidence/<timestamp>-<change-id>/`. Commit only sanitized summaries and evidence references. Never rewrite raw evidence; corrections are additive.
