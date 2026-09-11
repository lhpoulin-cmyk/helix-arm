# Required custom Docker image

Status: **required, not built, not deployed**. The operator explicitly requested importing the source fixes and recording the need for a custom image. A stock ARM image does not contain these fixes. Compose requires `HELIX_ARM_IMAGE` and disables implicit pulls; an unset value fails configuration validation.

## Smallest implementation plan

1. Create an isolated upstream checkout at commit `8c140c88919f2d5230dc828c56051f727eb8d50a` and initialize the dependency submodule at the recorded revision. Apply the complete [patch series](../patches/arm/README.md). Verify the resulting tree and run the 18 focused tests.
2. Review upstream `Dockerfile` and its `automaticrippingmachine/arm-dependencies:1.8.0` base. Resolve and pin its actual digest for reproducibility. Preserve upstream startup behavior; avoid rebuilding FFmpeg or media drivers or introducing additional services.
3. Add a minimal build definition/build instructions to this repository that package the patched checkout. Keep the build context confined to that checkout; never include the appliance workspace, private age key, SOPS plaintext, runtime database, media, or evidence. Capture source/patch/base-image checksums and tool versions.
4. Build and tag a local image such as `helix-arm:2.24.3-reliable-ingest`. A proposed tag is not proof that it exists or includes the fixes. Inspect files, labels and image ID, execute relevant tests inside the image, and retain build logs. Record the final immutable image identity and how to rebuild it.
5. Set `HELIX_ARM_IMAGE` to the verified local tag/identity, reconcile persistent ARM configuration with patched defaults, and use the existing Compose bind mounts. Start the dashboard without optical mappings, initialize and change the admin login, and verify it before enabling a drive.
6. Resolve the new SATA drive mapping and permissions; retain ripping-only operation. Execute representative-disc acceptance and production VA-API regression after Docker installation. Do not retire the old pipeline until acceptance succeeds.

## Current prerequisites

Guest sudo authentication blocked the last Docker package installation attempt. Docker installation must be rechecked because the operator was subsequently given an installation command. No new installation success is assumed.

The last verified optical inventory contained the previous USB drive and the QEMU virtual drive, not the operator-reported new SATA drive. Verify identity and block/SCSI pairing anew. Host controller assignment is outside guest authority.

For rollback, stop ARM, retain all logs/media/database, and restore a previously validated image/configuration/database if one exists. No validated Helix ARM custom image exists yet. Reverting to stock loses these fixes and requires explicit acceptance of that limitation.
