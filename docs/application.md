# Application scope

Helix ARM uses ARM for disc inspection and MakeMKV ripping, with a dashboard and retained job diagnostics. The trial is ripping-only. Hardware encoding remains a separate appliance function with explicitly selected device, API, and encoder; production currently uses VA-API av1_vaapi. ARM does not need GPU access for this trial.

Flow: physical disc → ARM/MakeMKV → dedicated unvalidated trial storage → probe, full audio/video decode, checksums, and preservation review → separate encoding and promotion.

Preserve original media and all requested titles, audio, subtitles, chapters, language tags, useful metadata, HDR signalling, and color metadata. Verify MakeMKV track selection explicitly. Do not infer preservation from the ripping-only settings. No automatic deletion, library refresh, external notifications, creative media transformations, or promotion is part of this trial.

ARM completion is not validation or permission to publish an output. Failed and partial jobs retain inputs, outputs, and logs. Validation records must identify the input, tools and versions, command, timestamps, exit statuses, probes, decode results, checksums, and provenance. Final promotion is a separate operation after acceptance, atomic within one filesystem.

This is a narrow ARM/Docker exception on an encode-only appliance. Host controller assignment, passthrough, storage infrastructure, and VM hardware changes remain operator/host responsibilities.
