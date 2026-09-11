# Helix ARM execution plan

The first milestone is a verified patched image and a working loopback-only dashboard with a changed administrator login. Optical access is deliberately deferred.

| Phase | Owner | Action | Acceptance | Stop condition | Rollback |
| --- | --- | --- | --- | --- | --- |
| 1. Guest readiness | Guest operator | Re-run the documented package simulation, install Docker with local sudo authentication, then verify Docker, mounts, capacity, inode reserve, and unchanged FFmpeg. | Docker and Compose respond; `/mnt/media/work` is the expected ext4 mount; root reserve passes. | Any removal, unrelated upgrade, wrong/missing mount, inadequate reserve, or FFmpeg change. | Do not start ARM; retain the package-before evidence and simulate removal before undoing packages. |
| 2. Patched image | Codex commands, guest operator execution | Prepare the pinned upstream checkout with `scripts/prepare-arm-source.sh`; resolve the amd64 digest for `arm-dependencies:1.8.0`; build with `scripts/build-arm-image.sh`. | Upstream and submodule commits match; patched tree is exactly `9a8c6b01166ed64f3c85fbc76822bce0e59a30b1`; 18 tests pass; image labels and ID are recorded. | Any commit/tree/test/digest mismatch or unexpected Dockerfile form. | Leave the failed checkout/image unused; retain logs; do not prune shared Docker data. |
| 3. Dashboard/login | Guest operator | Set `HELIX_ARM_IMAGE` locally, validate Compose, start without devices, initialize the database, and apply the SOPS-held login locally. | Health check passes through `127.0.0.1:8080`; new login succeeds; bootstrap/old password fails; image identity and mounts match. | Broad network exposure, plaintext secret leakage, migration error, unhealthy service, or identity mismatch. | `docker compose stop`; retain bind-mounted database, config, logs, and encrypted credentials. |
| 4. Optical discovery | Guest operator; hypervisor operator only if controller assignment is absent | Inventory the physical SATA drive and its block/SCSI peer before editing Compose. | Model/serial/controller evidence identifies one intended physical drive and matching `/dev/srN` plus `/dev/sgN`; MakeMKV registration/track policy is known. | Only USB/virtual drives appear, pairing is ambiguous, or host assignment is required. | Make no device mapping; dashboard remains independently usable. |
| 5. Trial rip | Guest operator | Map only the verified drive using the minimum working permissions and rip one representative disc into dedicated trial storage. | Command, versions, logs, provenance, exact outputs, preservation, probe, full decode, and checksum all pass. | Mount/reserve failure, source-write risk, track uncertainty, collision, software encode fallback, or incomplete diagnostics. | Stop ARM; preserve source, partial output, database, and logs for diagnosis. |
| 6. Coverage/regression | Guest operator | Test DVD/Blu-ray, restart/reinsertion and failure/collision behavior, then run the existing appliance and VA-API AV1 smoke tests. | All acceptance checks and hardware AV1 regression pass with new evidence. | Any source loss, silent replacement, dropped track, stale device mapping, or hardware regression. | Keep the prior ingestion pipeline authoritative and Helix ARM isolated. |

## Immediate operator gate

On `b70-encode-matrix`, from `/srv/b70-encode/scratch/helix-arm`, first run the exact Docker package simulation described in [deployment](deployment.md). If it is clean, authenticate locally and run the pinned install command there. Never paste the sudo password, decrypted SOPS values, or age identity into chat.

After Docker is available, resolve and record the amd64 base-image digest before building:

```bash
sudo docker pull --platform linux/amd64 automaticrippingmachine/arm-dependencies:1.8.0
sudo docker image inspect automaticrippingmachine/arm-dependencies:1.8.0 \
  --format '{{index .RepoDigests 0}}'
```

The output supplied to the build script must have the form `automaticrippingmachine/arm-dependencies@sha256:...`. Preserve it with the build evidence.

```bash
bash scripts/prepare-arm-source.sh
sudo bash scripts/build-arm-image.sh \
  ./scratch/arm-patched \
  automaticrippingmachine/arm-dependencies@sha256:<recorded-digest>
```

Run the focused tests in the prepared checkout before treating the image as eligible for Compose:

```bash
python3 -m unittest discover -s ./scratch/arm-patched/test/local -v
```

This plan does not claim Docker, the image, dashboard, login, optical device, or disc acceptance is currently complete.
