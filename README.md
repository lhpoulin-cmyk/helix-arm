# Helix ARM

Helix ARM documents our Automatic Ripping Machine (ARM) media-ingestion application: reproducible disc ripping, retained diagnostics, output validation, and handoff to a separate hardware-encoding pipeline.

This repository holds application documentation, a pinned stock Docker Compose configuration, and SOPS-encrypted login credentials. Runtime directories and ripping-only configuration are prepared; Docker installation and live acceptance are blocked on guest sudo authentication. The application builds on upstream ARM, not a newly implemented ripper.

## Documentation

- [Current state](CURRENT_STATE.md)
- [Application architecture and media policy](docs/application.md)
- [Deployment and rollback](docs/deployment.md)
- [Exact storage layout and recovery](docs/storage.md)
- [SOPS credentials and dashboard access](docs/secrets.md)
- [Pinned Compose configuration](compose.yaml)
- [Acceptance checklist](docs/acceptance.md)
- [Upstream and local reliability changes](docs/upstream.md)
- [Ripping-only configuration fragment](config/arm-overrides.example.yaml)
- [Changelog](CHANGELOG.md)

No media, plaintext credentials, private device identities, raw evidence, or runtime state belongs in Git. SOPS-encrypted login YAML is explicitly authorized. Repository creation does not install Docker or start ARM.
