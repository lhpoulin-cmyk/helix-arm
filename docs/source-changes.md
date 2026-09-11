# Complete source change inventory

The imported two-commit series modifies ten files, adding 377 lines and removing 164 against ARM 2.24.3. The [mailbox patch](../patches/arm/0001-reliable-ingest.patch) includes the implementation and tests.

| Source file | Resulting behavior |
| --- | --- |
| `arm/ripper/logger.py` | Disable automatic age deletion; use exclusive UUID log names; route early root logging to retained logs. |
| `arm/ripper/main.py` | Preserve original startup exceptions; retain early logging if job-log creation fails; record job identity; handle absent start times; persist failures and return nonzero without overwriting existing failure status. |
| `arm/ripper/makemkv.py` | Capture stdout/stderr together at INFO with command and exit status; tolerate text decoding; bound error-tail storage; terminate child processes when parsing/consumption aborts. |
| `arm/ripper/utils.py` | Require the exact requested nonempty regular file; reject substitution, symlinks, and destination collisions; install without replacement via hardlink/unlink; propagate failures before cleanup or success. |
| `arm/ui/utils.py` | Return complete finite log snapshots, handle invalid UTF-8 visibly, and avoid endless EOF spinning. |
| `arm/ui/logs/templates/logview.html` | Poll finite snapshots and safely escape script parameters. |
| `scripts/docker/docker_arm_wrapper.sh` | Preserve the Python process failure exit status through the wrapper. |
| `setup/arm.yaml` | Default raw cleanup off and log lifetime zero; explain retained-log behavior. |
| `arm/ui/comments.json` | Align UI retention guidance with the patched behavior. |
| `test/local/test_reliability.py` | Eighteen focused tests for logging, subprocess handling, exact output/collision behavior, viewer syntax, and failure/success state. |

## Operational constraints

Raw and completed directories must share a hardlink-capable filesystem. Cross-filesystem installation fails and preserves the input. If linking succeeds but unlinking fails, both names remain and the job fails; inspect the collision before retrying. No approximate filename fallback remains in the installation path.

Retain job, progress, and service logs. Captured MakeMKV diagnostics are decoded text, not a byte-for-byte binary transcript. Higher verbosity requires capacity monitoring and explicit archival. Automatic external log rotation is not implemented by these patches.

Ripping-only settings remain required. These changes do not add the appliance's full probe/decode/checksum/preservation gate or permit automatic promotion. They do not fix the stock Flask session-signing key or establish MakeMKV track preservation. Keep dashboard access on loopback through SSH pending a separate exposure review.

## Validation and remaining work

Fresh patch replay exactly matches source tree `9a8c6b01166ed64f3c85fbc76822bce0e59a30b1`; 18 tests pass. Python compilation, wrapper syntax and whitespace checks pass. No Docker image build, full dependency-backed upstream test suite, browser integration, real-disc trial, or post-install GPU regression was performed for this import.

The [historical source review](source-review.md) explains the reproduced defects. Original source and raw evidence remain additive in the appliance workspace. The [custom image](custom-image.md) is required to deliver these fixes in the application.
