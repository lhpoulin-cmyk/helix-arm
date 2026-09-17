## 2026-09-17 — Optional metadata and scoped manual selection

OMDb requests now stop locally when its key is absent/empty, with a clear reduced
metadata message. No secret is logged. Exact manual job/inventory/title overrides
now work for unknown classification; automatic policies still require movie
classification and known series routing is unchanged. This corrects a selector
gate that previously rejected a valid manual override before examining it.
Independent replay passes48 B70 tests and43 product tests, including25 focused
selection/metadata tests. No runtime installation or disc operation occurred.
The additive0005 patch follows0004; arm-cp owns deployment and recovery.

## 2026-09-16 — Configurable movie-selection wait (prepared)

MOVIE_SELECTION_WAIT_SECONDS defaults to1800; testing may set60. Movie waits
poll every5seconds against a monotonic deadline, reject invalid values and stop
without ripping at timeout. TV waits and MANUAL_WAIT_TIME remain unchanged.
The setting is captured at job startup and cannot shorten an active old worker.
Four timeout regressions pass; independent replay passes45 B70 tests and40
product tests, including22 focused selection tests. No live installation or
processing is claimed. Apply0004 after0003; arm-cp owns deployment and rollback.

## 2026-09-16 — Manual selection UI correction (prepared)

Movie fallback set waiting without manual_mode, leaving job-detail controls
disabled. The additive [patch](patches/arm/0003-manual-selection-ui.patch) sets
that flag and exposes controls for existing non-series waiting jobs. Submitted,
active and terminal jobs remain disabled; TV behavior, authentication and CSRF
are unchanged. Three form-level regressions supplement the routing assertion.
41 B70 source tests pass, including18 focused selection tests. Source tests do
not establish installation or live extraction. arm-cp owns the workload upgrade;
retain the prior image for rollback and all job/media records.

# Current state

## 2026-09-16 — Movie-selection source repair verified, not deployed

A small MakeMKV selector supports explicit attribute49 identification, opt-in
chapter/size heuristics, and manual title IDs bound to an ARM job and inventory.
Default fallback is existing operator selection; series routing is unchanged.
The sanitized 139-title regression selects title32 / playlist00609.mpls via the
unique FPL_MainFeature attribute; legacy heuristics select128. This is retained
inventory evidence, not fresh disc binding or successful extraction.

Independent replay passed33 product tests and38 B70 application-source tests,
including15 focused policy/parser/routing regressions. No rip, runtime update,
image build or privilege change occurred. B70 workload pins remain with arm-cp;
source publication does not install this repair. See [movie selection](docs/movie-selection.md)
for configuration, limitations and rollback. Older entries below are historical.

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
