# Changelog

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
