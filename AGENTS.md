# Helix ARM repository instructions

Maintain documentation and sanitized example configuration for the ARM media-ingestion application. Prefer upstream software and configuration over custom development. This repository does not authorize deployment, host changes, or deletion of media.

Before implementation or diagnostics on an appliance, read its AGENTS.md and active hardware profile and verify observed state. Keep source media immutable. Verify exact external mounts and capacity before access or substantial writes. Keep ARM ripping-only until explicitly changed; encoding and validated promotion are separate steps.

Never commit private identities, credentials, media, raw evidence, runtime logs, or job/database state. Record hardware reports separately from verified observations. Update CURRENT_STATE.md, CHANGELOG.md, and relevant runbooks after changes, validate links/configuration, and commit sanitized artifacts. Document rollback and state which live tests remain unperformed.
