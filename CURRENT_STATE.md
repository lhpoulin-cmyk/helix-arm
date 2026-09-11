# Current state

## 2026-09-11 — Custom-image bootstrap prepared

A review branch now contains a bounded six-phase execution plan plus fail-closed source-preparation and image-build scripts. The source script pins the upstream and dependency commits and verifies the expected patched tree. The build script requires a digest-pinned `arm-dependencies` image and records image identity labels. Shell syntax was checked in ChatGPT Work; Docker, image, application, login, disc, and hardware acceptance remain unperformed. Guest Docker installation still requires the operator's local sudo authentication.


## 2026-09-11 — Reliability fixes imported; custom image required

The operator requested merging the source fixes into Helix ARM. The complete two-commit patch series, including all 18 tests and upstream license, is now tracked under `patches/arm/`. Detailed source inventory and the original review are in `docs/source-changes.md` and `docs/source-review.md`. This supersedes the stock-image choice recorded below.

Fresh replay against the pinned upstream base produced exactly the original fixed source tree `9a8c6b01166ed64f3c85fbc76822bce0e59a30b1`; all 18 tests, Python compilation, shell syntax, and whitespace checks passed. Author headers were sanitized; source hunks are unchanged. Evidence: `/srv/b70-encode/evidence/20260911-helix-arm-source-import/`.

A custom Docker image containing these changes is required and has not been built. Compose now requires `HELIX_ARM_IMAGE` and uses `pull_policy: never`, preventing an implicit stock-image deployment. See `docs/custom-image.md`. No runtime, media, or encoder changes were made, so no new production encode was run for this source packaging change; the earlier pre-Docker baseline remains available and post-install regression remains pending.

A fresh guest check still finds no Docker executable, an inactive Docker service, interactive sudo authentication, and only the prior USB and virtual optical drives. Login application and live acceptance remain pending. `docs/chatgpt-work-handoff.md` gives ChatGPT Work a concrete plan-design brief aimed at a working custom image/dashboard first, then the verified SATA drive and validated ripping.

## 2026-09-11 — Stock Compose deployment prepared; installation blocked

The operator authorized a normal stock Docker installation and SOPS-encrypted credentials in Git. Compose pins upstream ARM 2.24.3 by digest, with a loopback dashboard and persistent local bind mounts. Dedicated home/config/log directories now exist under `/srv/b70-encode/var/helix-arm`; dedicated media/music directories exist under verified `/mnt/media/work/helix-arm`. The complete stock configuration plus ripping-only overrides is staged. See [installation](docs/deployment.md) and [storage](docs/storage.md).

SOPS 3.13.3 and age 1.2.1 are installed under `/home/louis/.local/bin`. The age identity is outside Git with mode 0600. `secrets/login.sops.yaml` contains a generated administrator password and bootstrap information; authenticated decrypt and canonical YAML SHA-256 round-trip passed. **The password has not been applied because ARM is not installed.** Private-key backup remains an operator recovery step.

Docker/Compose apt installation is blocked by interactive sudo authentication. No Docker daemon, image, container, or live dashboard has been installed/started. Package simulation proposes no upgrades/removals. The Compose file passes validation with Ubuntu Compose 2.40.3, extracted locally without a package installation. No source media or production encoder configuration changed.

Guest-level access resolves the earlier sandbox device-visibility limitation: `/dev/dri/renderD128` works with Intel xe/iHD. Appliance smoke and the ten-second 1920x1080p30 synthetic VA-API av1_vaapi baseline passed with FFmpeg 8.0.1-3ubuntu2, AV1 Main output, full decode, and SHA-256 `da5c343d416891e1379bda651f2e10e8dfc2d774715925773dfd2235cb9e93df`. This is a pre-Docker baseline, not post-install regression. Evidence: `/srv/b70-encode/evidence/20260911-arm-docker-setup/`.

The new SATA drive is still not visible. The existing USB drive is `/dev/sr1` with `/dev/sg3`; the old profile's generic-SCSI mapping is stale. No optical mappings were enabled and no disc was accessed. Live login, new physical-drive mapping, DVD/Blu-ray acceptance, and post-install production regression remain pending. Stock upstream's fixed session-signing key also limits this trial to localhost access; see [secrets](docs/secrets.md).

## 2026-09-11 — Repository established

ARM 2.24.3 is staged in the existing appliance workspace. Local reliability changes are packaged there; the retained 2026-09-10 test record reports 18 passing focused tests. These are source-level tests, not full application or disc acceptance. Docker packaging, runtime installation, dashboard checks, live ripping, and production encoding regression remain pending.

The operator reports that the SATA Blu-ray drive is now on a new controller. This is an operator-reported hardware update, not a verified guest mapping. The maintenance session still enumerates a USB HL-DT-ST BD-RE BP50NB40 and a virtual QEMU DVD-ROM; it does not identify the new physical SATA drive/controller. Do not reuse the old block/SCSI mapping without verifying the new drive.

The active appliance profile expects Intel Battlemage, kernel driver xe, userspace iHD, and production VA-API av1_vaapi. PCI inspection sees Intel Battlemage using xe. Render and optical device nodes are not visible in this restricted session; hardware operation is unverified here. No host changes are authorized by this repository task.

Only documentation and example configuration were added. No package, service, source media, or production encoder changed. Hardware regression was not run for this documentation-only change.
