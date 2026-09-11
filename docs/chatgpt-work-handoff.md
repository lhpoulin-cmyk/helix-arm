# ChatGPT Work handoff: get Helix ARM running

## Request to ChatGPT Work

Help me design a short, executable plan to get Helix ARM running as soon as possible. Use the existing work and keep the Docker setup conventional. Prioritize a working dashboard and verified login, then a validated real-disc rip. Do not restart the project, replace the ripper, add unrelated infrastructure, or design a large custom framework. Separate confirmed facts from assumptions and identify which commands belong to the guest operator versus the hypervisor operator. Give Codex concrete, bounded implementation steps and acceptance criteria.

Repository: https://github.com/lhpoulin-cmyk/helix-arm (private; use an authorized connection or ask me for the relevant files if inaccessible). Start with `CURRENT_STATE.md`, `docs/custom-image.md`, `docs/deployment.md`, `docs/storage.md`, `docs/source-changes.md`, and `compose.yaml`. Do not request decrypted secrets or the age private key in chat.

## Intended application

ARM handles media/disc inspection and MakeMKV ripping, retaining outputs for separate validation and hardware encoding. It is a replacement trial intended to reduce maintenance. Host is `b70-encode-matrix`; working repository is `/srv/b70-encode/scratch/helix-arm`. The appliance remains encode-only except for the explicitly authorized ARM container and required Docker runtime.

The operator initially requested normal stock Docker configuration, then explicitly requested merging the reliability fixes and creating a custom image. **The current decision is patched upstream ARM in a minimal custom image.** A normal Compose deployment is still desired; stock ARM does not satisfy the source-fix requirement.

## Completed and verified

- The complete two-commit patch series and its 18 tests are in `patches/arm/0001-reliable-ingest.patch`, with upstream license and application instructions.
- Upstream base: ARM 2.24.3, commit `8c140c88919f2d5230dc828c56051f727eb8d50a`; dependency submodule `3a04c4d4bed76458d09361ba4878bf72c1711f50`.
- Fresh application reproduces tree `9a8c6b01166ed64f3c85fbc76822bce0e59a30b1`. All 18 focused tests, Python compilation, wrapper syntax, and whitespace checks pass. These are not full-app/live acceptance.
- Fixes retain logs, improve MakeMKV diagnostic capture, install only the exact nonempty requested output without replacement, propagate failures, and repair log viewing. Detailed per-file inventory is in `docs/source-changes.md`.
- Compose defines one container, UTC, UID/GID 1000:1000, persistent bind mounts, restart-unless-stopped, and localhost port 8080. It requires `HELIX_ARM_IMAGE`; no default stock image or implicit pull remains. No optical device/GPU mapping is enabled.
- Application home/config/log directories exist under `/srv/b70-encode/var/helix-arm`. Media and music roots exist under `/mnt/media/work/helix-arm`. Complete ripping-only runtime configuration is staged.
- Workspace/root filesystem had about 79 GiB free; verified ext4 work mount `/dev/sdb[/work]` had about 241 GiB free. Recheck before use. Keep root reserve at the greater of 30 GiB or 20 percent. Raw and completed paths share the work filesystem, meeting patched hardlink requirements.
- SOPS 3.13.3 and age 1.2.1 are installed under `/home/louis/.local/bin`. `secrets/login.sops.yaml` passed authenticated decrypt and SHA-256 round-trip. Generated admin credentials are **not applied** to a running service.
- Private age identity: `/home/louis/.config/sops/age/helix-arm.txt`, mode 0600, outside Git. Operator plans to copy it into the Foundation vault attached to `louis@ws-hadrian`. Name resolution prevented this transfer; no vault backup has been verified.
- Pre-Docker production baseline passed: Intel xe/iHD 26.1.2, `/dev/dri/renderD128`, FFmpeg 8.0.1-3ubuntu2, explicit VA-API av1_vaapi, ten-second 1920x1080p30 synthetic AV1 Main output, probe, full decode, and checksum. Post-install regression is still required.

## Unresolved prerequisites

Latest guest recheck during this handoff: no Docker executable found, Docker service inactive, and sudo still requires interactive authentication. The USB/virtual optical inventory is unchanged.

1. Docker installation was blocked by interactive sudo authentication. The operator received `sudo apt-get --no-install-recommends --no-remove install docker.io docker-compose-v2`. Recheck whether they ran it. Do not bypass authentication or ask for their sudo password in chat. The candidate versions recorded were Docker 29.1.3-0ubuntu4.1 and Compose 2.40.3+ds1-0ubuntu1 from existing Ubuntu repositories, with no proposed removals/upgrades in the recorded simulation.
2. The custom image has not been built or tested. Upstream Dockerfile uses `automaticrippingmachine/arm-dependencies:1.8.0`; resolve/pin its digest and use the patched source with the smallest build change. Avoid rebuilding the media stack. Keep secrets/runtime directories out of build context.
3. The operator moved a SATA Blu-ray drive to a new controller. It is not yet identified in the guest. Last observations: USB HL-DT-ST BD-RE BP50NB40 at `/dev/sr1` with `/dev/sg3`; QEMU virtual DVD-ROM at `/dev/sr0` with `/dev/sg2`. The appliance profile's old `/dev/sg2` pairing is stale. Never use it blindly. Ask the host operator only for any required controller/VM assignment work.
4. Upstream optical startup examples use privileged mode; settle the minimum working device/permission configuration within appliance authority. Do not silently substitute the USB or virtual drive, expose unrelated disks, or add GPU access to a ripping-only service.
5. Stock ARM 2.24.3 has a fixed Flask signing key not addressed by these patches. Keep loopback plus SSH tunnel for the initial trial; do not expose the dashboard broadly without addressing authentication/session protection.

## Requested plan and sequence

Produce a small ordered plan with exact commands/configuration changes, owner, expected result, stop condition, and rollback for each phase:

1. Resolve Docker/sudo readiness, confirm exact storage mounts/capacity and image-build dependencies. Preserve FFmpeg and existing media.
2. Build patched ARM reproducibly from pinned source/base; verify the packaged changes and relevant tests; record image identity.
3. Start dashboard without disc access. Use the SOPS credentials locally, initialize the upstream database if necessary, replace bootstrap password, verify new login and rejection of the old password. Update encrypted credential status only after success.
4. Map the verified physical SATA drive and its SCSI peer. Inspect before ripping; confirm MakeMKV registration and track-selection needs without inventing keys or dropping tracks.
5. Perform one representative rip to dedicated trial storage; retain command/version/log/provenance, verify exact outputs and preservation, probe/full-decode/checksum. Then cover DVD and Blu-ray, restart/repeated insertion, and failure/collision cases.
6. Regress the explicit production VA-API encode after runtime changes. Record results, update state/runbooks, and commit/push sanitized artifacts. Keep the prior ingestion system until replacement acceptance passes.

Keep the first working milestone small. Do not require a reverse proxy, public registry, CI pipeline, new filesystem, or a full source fork before proving a local custom image and dashboard. If a prerequisite blocks ripping, complete dashboard/image work independently and name the remaining blocker precisely.

## Non-negotiable boundaries

Source media is immutable. No deletion, overwrite, automatic library promotion, unrequested track loss/transformation, or software encoder fallback. Verify exact external mounts; never spill a large rip onto root because a mount is missing. Preserve diagnostics and failed output. Container completion is not validated output. Host GPU/storage/passthrough changes belong to the host operator. Never commit plaintext secrets, private keys, raw evidence, media, logs, or runtime database state.

## Deliverables back to Codex

An agreed minimal custom-image build approach; installation/startup commands; selected optical-device strategy with explicit unknowns; dashboard/login and first-rip acceptance checks; rollback preserving state; and a short list of actual remaining operator actions. Codex can implement guest/repository changes once prerequisites are available. Do not claim a deployment is running based on a plan, a successful source test, or a generated password.
