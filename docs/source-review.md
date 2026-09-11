Historical source review, before implementation of the fixes now packaged in `../patches/arm/`. Statements below that fixes are proposed describe that earlier review, not current patch status. See [source changes](source-changes.md). Evidence paths refer to the original appliance workspace.

# ARM 2.24.3 code review — logs and output integrity

Reviewed upstream release 2.24.3, commit
`8c140c88919f2d5230dc828c56051f727eb8d50a`, in `scratch/arm-evaluation`.
This is a source review and isolated reproduction, not live Docker, optical,
browser, or GPU acceptance. No upstream code or production runtime was changed.

The proposed `LOGLIFE: 0` setting really disables ARM's age-based deletion of
job and progress logs. It does not make every diagnostic reach the job log,
repair the viewer, or ensure that completion means all output was installed.
Keep ARM as a candidate for an isolated trial; do not treat its success state
as sufficient for promotion.

## Findings

### P1 — age cleanup can remove active-job evidence

`arm/ripper/logger.py:67` scans LOGPATH and its progress subdirectory and
unlinks `.log` files based only on modification time. The default is one day.
`arm/ripper/main.py:224` invokes cleanup during each new job's setup. There is
no check of active jobs, failures, open handles, or retained history records.

Reproduced: cleanup removes a three-day-idle log while its writer still holds
it open. Subsequent writes succeed to the unlinked inode but are inaccessible
by filename and disappear when that descriptor closes. This requires another
job to trigger cleanup and an old mtime, not merely a long-running job.
The history template (`arm/ui/history/templates/history.html:81`) continues
linking to job.logfile. This explains the stale-link mechanism reported in
[issue #866](https://github.com/automatic-ripping-machine/automatic-ripping-machine/issues/866).

Mitigation: `LOGLIFE: 0`, verified with old job and progress files. Persist the
log directory outside the container and decide archival separately. This is
not a claim that Docker log rotation or external cleanup is also disabled.

### P1 — full MakeMKV diagnostics are absent from the per-job log

`arm/ripper/makemkv.py:1246` starts MakeMKV with stdout piped but stderr
inherited. Raw stdout and the command are logged only at DEBUG. At the default
INFO level, the saved log is not a complete transcript. On error the collected
buffer is passed to `MakeMkvRuntimeError`, which also logs that detail at DEBUG
(`arm/ripper/makemkv.py:474`). Stderr may reach container/service output; it is
not deliberately captured and associated with the job's file.

There is an additional startup routing gap: `create_early_logger` attaches its
file handler to the named `ARM` logger (`logger.py:120`), while setup and its
exception handler use root logging. Reproduced that root messages do not reach
the early logger's file. After setup_job_log the root file handler exists, but
failures before that point need the service/console output for diagnosis.

Mitigation: retain service output as well as job/progress files. DEBUG helps
with MakeMKV stdout but does not solve stderr routing. Durable per-job capture
of both streams is a focused candidate fix; it has not been implemented.

### P1 — failed moves can be followed by raw-output deletion and success

`arm/ripper/utils.py:315` catches every move exception, logs it, and returns
normally. `arm/ripper/arm_ripper.py:91` proceeds from moving files to cleanup;
`main.py:268` assigns success if the processing call returns without raising.
An existing destination is also skipped without checking its content.

Reproduced the move/cleanup functions in that order: a simulated permission
failure leaves the generated rip present, then enabled cleanup removes it,
with no destination output. The full application job-state transition was
traced in source, not executed. This matches the class of failure in
[issue #1226](https://github.com/automatic-ripping-machine/automatic-ripping-machine/issues/1226),
without claiming to reproduce every reported disc/filename case.

`DELRAWFILES: false` prevents this cleanup path. It does not make a failed move
fail the job. A minimal fix would propagate the error and gate cleanup on
successful verified installation. Existing media stays outside ARM's writable
trial directories.

### P1 — approximate filename matching can select the wrong episode

`arm/ripper/utils.py:260` searches for a similar filename if the expected one
is absent. Its scoring threshold accepts another numbered episode; there is
no identity/content check. `move_files_main` then moves that substitute.

Reproduced: only Episode02.mkv exists, Episode01.mkv is requested, and the
Episode02 bytes are moved to the requested destination without an error.
This path also serves ripping-only jobs. Disabling cleanup does not prevent
it. Exact matching with an explicit failure is preferable for this appliance;
an ambiguous match should require operator review.

### P2 — expired log names can be reused and misidentify historical evidence

`arm/ripper/logger.py:41` uses DISC_LABEL.log unless that file already exists;
only then is a stage suffix added. After retention deletes it, a later rip of
the same label gets the original filename again. The old job's history link
can therefore show the new job's log. Reproduced sequentially with two jobs.
Always using a unique job identifier would avoid this. LOGLIFE=0 prevents the
tested retention-triggered case, but is not itself a uniqueness guarantee.

### P2 — viewer failures are separate from deleted files

`arm/ui/utils.py:384` busy-loops at EOF in the ARM-filtered viewer: sleep is
inside the nonmatching-line branch, not the EOF branch. A bounded fake reader
performed 1,000 empty reads with no sleep. Each streaming view occupies a
server worker; the deployed server is configured for 40 threads. The full
viewer also streams indefinitely for completed logs, though it sleeps at EOF.

`arm/ui/utils.py:363` does not catch UnicodeDecodeError, so invalid UTF-8 aborts
the full viewer instead of reaching its intended tolerant fallback. Reproduced
with a disposable invalid-byte log. A valid large log including its final
sentinel was returned completely by the same generator.

[Issue #1561](https://github.com/automatic-ripping-machine/automatic-ripping-machine/issues/1561)
reports a truncated GUI view but a complete download. The exact browser/server
truncation reported there was not reproduced or diagnosed here. It should not
be conflated with age deletion. Use the actual persisted file/download as the
reference during a trial; repair EOF handling and decoding separately.

## Other source observations

- `main.py:264` dereferences job in its exception handler even if setup failed
  before creating one. This can mask an initial setup failure with a second
  exception. Its finally block can also access `.seconds` on integer zero if
  a job exists without start_time (`main.py:274`). Not exercised end to end.
- Music/data paths can return a failure without raising, after which the outer
  success assignment overwrites the status. These are outside the proposed
  DVD/Blu-ray trial, but broad auto-detection must not imply they are accepted.
- `arm_setup` logs unwritable paths without raising and creates missing
  directories (`utils.py:620`). It does not enforce this appliance's exact
  mount or free-space contract. Deployment must enforce those prerequisites.

## Evidence and disposition

Evidence: `evidence/20260910T022945Z-arm-code-review/`. Run from the workspace:

```console
python3 evidence/20260910T022945Z-arm-code-review/corrected-probes.py
```

Nine source-level probes pass (pass means the documented behavior was
reproduced, including defects). They execute selected unmodified upstream
definitions with disposable files and mocked collaborators. Original probes
and results are retained: one initially failed because cleanup logging itself
refreshed the aged file's mtime. The additive corrected harness closes the
completed job's handler before simulating cleanup by another job.

Keep LOGLIFE=0 and DELRAWFILES=false for a trial. Persist all logging channels,
check them through startup, failure, restart, and repeated disc insertion, and
compare output inventory before acceptance. Prioritize exact output matching,
error propagation, and complete log capture if focused upstream fixes are
needed. No fixes were applied in this review. The staged upstream checkout
remains unmodified; no production regression was needed for this report.
