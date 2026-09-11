# Current state

## 2026-09-11 — Repository established

ARM 2.24.3 is staged in the existing appliance workspace. Local reliability changes are packaged there; the retained 2026-09-10 test record reports 18 passing focused tests. These are source-level tests, not full application or disc acceptance. Docker packaging, runtime installation, dashboard checks, live ripping, and production encoding regression remain pending.

The operator reports that the SATA Blu-ray drive is now on a new controller. This is an operator-reported hardware update, not a verified guest mapping. The maintenance session still enumerates a USB HL-DT-ST BD-RE BP50NB40 and a virtual QEMU DVD-ROM; it does not identify the new physical SATA drive/controller. Do not reuse the old block/SCSI mapping without verifying the new drive.

The active appliance profile expects Intel Battlemage, kernel driver xe, userspace iHD, and production VA-API av1_vaapi. PCI inspection sees Intel Battlemage using xe. Render and optical device nodes are not visible in this restricted session; hardware operation is unverified here. No host changes are authorized by this repository task.

Only documentation and example configuration were added. No package, service, source media, or production encoder changed. Hardware regression was not run for this documentation-only change.
