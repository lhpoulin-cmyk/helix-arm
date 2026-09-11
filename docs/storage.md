# Storage on this appliance

All paths below are guest-local. No NFS, SMB, new disk, partitioning, or host storage changes are involved. Values were inspected on 2026-09-11; recheck mounts and capacity before installation and every disc job.

| Host path | Container path / purpose | Filesystem |
| --- | --- | --- |
| `/srv/b70-encode/scratch/helix-arm` | Git checkout; Compose, docs, encrypted credentials | Existing root LV, ext4 |
| `/srv/b70-encode/var/helix-arm/home` | `/home/arm`; SQLite database at `db/arm.db`, MakeMKV settings under `.MakeMKV` | Existing root LV, ext4 |
| `/srv/b70-encode/var/helix-arm/config` | `/etc/arm/config`; complete `arm.yaml`, `apprise.yaml`, `abcde.conf` | Existing root LV, ext4 |
| `/srv/b70-encode/var/helix-arm/logs` | `/home/arm/logs`; job and progress diagnostics | Existing root LV, ext4 |
| `/mnt/media/work/helix-arm/media` | `/home/arm/media`; `raw`, `transcode`, and `completed` trial output | `/dev/sdb`, ext4, exact `/mnt/media/work` bind mount |
| `/mnt/media/work/helix-arm/music` | `/home/arm/music`; upstream music directory, outside DVD/BD acceptance | Same work filesystem |
| `/var/lib/docker`, `/var/lib/containerd` | Ubuntu runtime defaults for images, container layers, and engine metadata; inspect actual Docker info after installation | Existing root LV unless runtime inspection says otherwise |
| `/home/louis/.config/sops/age/helix-arm.txt` | Private age identity, mode 0600, outside Git and container | Existing root LV |

At preflight the root LV was about 98 GiB with 79 GiB available; work was about 251 GiB with 241 GiB available and approximately 16.8 million free inodes. Root must retain at least 30 GiB or 20 percent free, whichever is larger. The resolved amd64 image has about 0.91 GB of compressed layers; budget 8 GiB for image extraction and runtime setup, rechecking actual usage after pulling. No media-size allocation is implied by that runtime budget.

Before starting, use `findmnt -M /mnt/media/work` and confirm its source is `/dev/sdb[/work]`, filesystem ext4, and mount is writable. Directory existence alone is insufficient. Compose uses `create_host_path: false` so it does not fabricate missing bind directories. This does not replace the mount check: pre-existing directories on an unmounted filesystem can still be misleading.

Create only dedicated Helix ARM directories. Home/config/logs and the two media bind roots must be owned by UID/GID 1000:1000 to match `ARM_UID`/`ARM_GID`; upstream checks ownership. Use mode 0700 for application state and 0750 for trial media. Do not recursively chown the work mount or any pre-existing rip. No existing source/output/archive library is mounted in the container.

Raw and completed outputs share a filesystem. `completed` means ARM finished handling a file, not validated or promoted media. Stock ARM can move generated rips even with `DELRAWFILES: false`; all these paths therefore remain trial work storage. Preserve failure outputs and logs. Stop before a job if expected output, temporary use, and reserve do not fit; the dashboard alone is not an appliance free-space acceptance gate.

## Backup and recovery

Stop the container before a consistent backup of SQLite and configuration. Back up home, config, logs, all trial media, the pinned Compose file, and the encrypted credential file; copy the private age identity separately to operator-controlled secure storage. Do not commit database files, raw logs, MakeMKV registration, plaintext secrets, or media.

The generated age identity currently has only its local copy; recovery from host loss requires an operator backup or an additional recipient. Encryption in Git protects the credential file, not an unencrypted runtime database/configuration or Docker inspection output. Bind mounts persist across container recreation. Stopping/removing a container is not permission to remove these directories; never use cleanup/prune commands as rollback.

Service output uses Docker's json-file driver without automatic rotation. ARM `LOGLIFE: 0` disables age cleanup. Monitor disk usage and archive explicitly; do not allow retained diagnostics to exhaust the root reserve.
