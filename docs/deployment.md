# Deployment and rollback

This is a deployment checklist, not an installed service or runnable Compose definition. Resolve verified device paths, storage, image provenance, and application configuration before writing a launch command.

1. Verify the active appliance profile and observed guest hardware. Identify the newly reported SATA Blu-ray drive and its block/SCSI pair from guest sysfs and device metadata. Confirm physical identity and access; exclude the virtual DVD-ROM. Do not guess paths from the old USB mapping. If host assignment is required, report it to the operator.
2. Verify each intended external mount with `findmnt -M` before access. Check filesystem, available bytes and inodes, expected rip size, and scratch use. Retain the larger of 20 percent or 30 GiB free on local workspace storage. Never spill media onto root because a mount is absent.
3. Record installed/candidate Docker package versions, origins, dependencies, holds, active FFmpeg, proposed removals, and package rollback. Prefer Ubuntu packages. Stop if installation would remove the production stack. Do not add repositories or compile media runtimes without authorization.
4. Pin ARM source/image provenance. The initial trial authorization calls for unmodified upstream software. Local reliability patches also exist, and the later appliance runbook calls for a patched trial image. Resolve and record that baseline decision before building or deploying; do not silently treat stock ARM as containing those fixes. See [upstream notes](upstream.md).
5. Merge the [example overrides](../config/arm-overrides.example.yaml) into a complete generated configuration. Configure a verified MakeMKV preservation profile. Use dedicated trial raw/completed storage and persist configuration, database, and logs. The patched implementation requires raw and completed directories on one hardlink-capable filesystem. Existing media must not be exposed as writable scratch.
6. Map only the verified optical devices and required storage. Keep ARM GPU access unnecessary by retaining ripping-only operation. Document UI access controls before exposing the dashboard. Keep external notifications disabled.
7. Run [acceptance](acceptance.md), including separate production regression after runtime changes. Do not retire the existing ingestion system until the live replacement trial succeeds.

## Rollback

For this documentation repository, reverting a documentation commit restores the prior text; no runtime rollback is needed. Leave staged application work unused until deployment is ready.

Before deployment, record exact package/image/configuration versions and restoration steps. After deployment, stop ARM and restore the recorded service configuration/image as appropriate, preserving all trial media, database, and logs. Do not remove shared runtime packages without dependency review. Archival and deletion remain separate operator decisions.
