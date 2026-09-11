# Installation and rollback

## Selected deployment

Use one ARM container with Docker Compose, Ubuntu Docker packages, UTC, restart-unless-stopped, persistent bind mounts, and a loopback dashboard on port 8080. The operator subsequently requested that the reliability fixes be merged into Helix ARM. **A custom Docker image containing those fixes is now required and has not been built.** See [custom image](custom-image.md) before attempting startup.

Compose requires `HELIX_ARM_IMAGE` and uses `pull_policy: never` so an unpatched stock image cannot be selected by default. Only set this variable to a locally built and validated image containing the complete patch series. The previous stock baseline was ARM 2.24.3, multi-platform digest `sha256:86fe834229039a9b2715fe7d6417729c9963fcb7fd606a482d1edf7caf3b5a5d`; that digest does not include our fixes and is not the deployment image.

No optical device is mapped yet. The guest still sees the USB HL-DT-ST drive at `/dev/sr1`, now paired with `/dev/sg3`. `/dev/sr0` with `/dev/sg2` is the virtual QEMU drive, not the new physical SATA drive. The old appliance profile's `/dev/sg2` target is stale. Do not substitute either drive for the reported SATA drive. Controller assignment is a host/operator responsibility.

## Prepared on the guest

Dedicated paths in [storage](storage.md) exist with matching UID/GID 1000:1000. The complete runtime `arm.yaml` was generated from the recorded stock 2.24.3 configuration and merged with `config/arm-overrides.example.yaml`, plus `ARM_NAME: Helix ARM`, `DISABLE_LOGIN: false`, `WEBSERVER_IP: 0.0.0.0`, `UI_BASE_URL: http://127.0.0.1:8080`, and `AUTO_EJECT: false`. The host port remains loopback-only. Upstream initialization will supply `apprise.yaml` and `abcde.conf`. Without optical mappings, automatic disc ingest cannot start.

SOPS 3.13.3 and age 1.2.1 are installed as user-local tools. The encrypted planned administrator credential passed authenticated decrypt and canonical YAML SHA-256 round-trip validation. It is **not yet applied to an ARM account**. See [secrets](secrets.md).

## Docker installation — local sudo authentication required

The guest user has sudo membership but `sudo -n true` reports interactive authentication required. No Docker daemon or system package was installed. A local operator can authenticate in their terminal; do not send the password through chat. The focused installation command is:

```bash
sudo apt-get --no-install-recommends --no-remove install \
  docker.io=29.1.3-0ubuntu4.1 \
  docker-compose-v2=2.40.3+ds1-0ubuntu1
```

The recorded simulation with age included proposes five new packages, zero removals, zero upgrades. The command above omits age because user-local age is already available. Runtime dependencies are containerd 2.2.2-0ubuntu1.1 and runc 1.4.0-0ubuntu1. Docker comes from existing Ubuntu resolute-updates/security universe; Compose comes from resolute universe. No holds were reported. No repository addition, broad upgrade, or autoremove is needed. Preserve FFmpeg 8.0.1-3ubuntu2.

Rerun the exact simulation before installation and retain installed/candidate versions, dependencies, holds, and active FFmpeg. Stop if removals or unrelated production changes appear. The original baseline is under `/srv/b70-encode/evidence/20260911-arm-docker-setup/`.

After installation:

```bash
sudo systemctl is-active docker
sudo docker version
sudo docker compose version
sudo docker info
findmnt -M /mnt/media/work
df -h /srv/b70-encode /mnt/media/work
df -i /srv/b70-encode /mnt/media/work
```

First build and validate the [custom image](custom-image.md), set `HELIX_ARM_IMAGE` in the root invocation environment or a local ignored `.env`, and confirm the exact work mount and reserve in [storage](storage.md). Then:

```bash
cd /srv/b70-encode/scratch/helix-arm
sudo docker compose config --quiet
sudo docker compose up -d --wait --wait-timeout 180
sudo docker compose ps
sudo docker compose logs --no-color
```

Retain startup logs and inspect actual source/version labels, digest, UID/GID, mounts, and tool versions. Record Docker storage paths from `docker info`; a downloaded CLI's version output does not prove an installed daemon. Initialize and verify login through the SSH tunnel described in [secrets](secrets.md). Keep passwords out of command arguments and logs.

## Optical activation and acceptance

When the physical SATA drive is visible, verify identity, block/SCSI pair, access, and source preservation before adding mappings. Upstream's standard optical run example uses privileged mode; evaluate that explicitly against appliance device authority before enabling it. The current dashboard configuration is not a tested optical deployment. Do not mount the GPU, Docker socket, root filesystem, or existing media libraries.

Verify MakeMKV track selection. The imported fixes address the reviewed logging/output defects, but must still be verified in the built image and live workflow. They require raw/completed paths on one hardlink-capable filesystem. The complete runtime configuration was staged before this source import; reconcile it with patched defaults during image acceptance. Follow [acceptance](acceptance.md); ARM completion never promotes a file.

After the Docker transaction, run `/srv/b70-encode/tests/smoke/appliance` and `/srv/b70-encode/tests/smoke/vaapi-av1` with a fresh evidence output path. The latter runs a ten-second 1920x1080p30 synthetic VA-API av1_vaapi encode, probe, full decode, and checksum. Retain logs proving the hardware path, versions, and validation. Never overwrite earlier evidence.

## Rollback

Before startup no service needs undoing; prepared state can remain unused. After deployment, `sudo docker compose stop` stops ARM and preserves all bind-mounted data. Retain logs before container replacement. Restore the recorded image and a consistent configuration/database backup together for an application rollback. Do not delete media, logs, database, encryption identities, or prune Docker as rollback.

To reverse a Docker package transaction, stop ARM and inspect dependencies and other consumers. Simulate removal of only newly installed packages and obtain the required confirmation for removal. Do not purge, autoremove, or remove a shared runtime blindly. The package-before record identifies the baseline.

References: [upstream Docker installation](https://github.com/automatic-ripping-machine/automatic-ripping-machine/blob/main/arm_wiki/Docker.md), [ARM image](https://hub.docker.com/r/automaticrippingmachine/automatic-ripping-machine).
