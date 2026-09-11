# Helix ARM

Helix ARM documents our Automatic Ripping Machine (ARM) media-ingestion application: reproducible disc ripping, retained diagnostics, output validation, and handoff to a separate hardware-encoding pipeline.

This repository holds application documentation and example configuration. ARM is staged for a replacement trial; a running installation and production acceptance are still pending. The application builds on upstream ARM, not a newly implemented ripper.

## Documentation

- [Current state](CURRENT_STATE.md)
- [Application architecture and media policy](docs/application.md)
- [Deployment and rollback](docs/deployment.md)
- [Acceptance checklist](docs/acceptance.md)
- [Upstream and local reliability changes](docs/upstream.md)
- [Ripping-only configuration fragment](config/arm-overrides.example.yaml)
- [Changelog](CHANGELOG.md)

No media, credentials, private device identities, raw evidence, or runtime state belongs in Git. Repository creation does not install Docker or start ARM.
