# Helix ARM repository instructions

Maintain documentation and sanitized example configuration for the ARM media-ingestion application. Prefer upstream software and configuration over custom development. The operator authorized a standard stock ARM Docker deployment on 2026-09-11 and SOPS-encrypted login YAML in this repository. This does not authorize host changes or deletion of media.

Before implementation or diagnostics on an appliance, read its AGENTS.md and active hardware profile and verify observed state. Keep source media immutable. Verify exact external mounts and capacity before access or substantial writes. Keep ARM ripping-only until explicitly changed; encoding and validated promotion are separate steps.

Never commit private identities, plaintext credentials, media, raw evidence, runtime logs, or job/database state. SOPS-encrypted credential YAML is authorized after an authenticated decrypt and SHA-256 round-trip; private age keys remain outside Git. Record hardware reports separately from verified observations. Update CURRENT_STATE.md, CHANGELOG.md, and relevant runbooks after changes, validate links/configuration, and commit sanitized artifacts. Document rollback and state which live tests remain unperformed.
