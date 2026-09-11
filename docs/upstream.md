# Upstream and local changes

Upstream project: https://github.com/automatic-ripping-machine/automatic-ripping-machine

The existing appliance record identifies release 2.24.3 at commit `8c140c88919f2d5230dc828c56051f727eb8d50a`, with dependency submodule `3a04c4d4bed76458d09361ba4878bf72c1711f50`. These are staged provenance records, not a claim about the latest upstream release.

Local branch `matrix/reliable-ingest` in `/srv/b70-encode/scratch/arm-evaluation` contains reliability changes. The patch and application instructions remain at `/srv/b70-encode/patches/arm/0001-matrix-reliable-ingest.patch` and `/srv/b70-encode/patches/arm/README.md`. This documentation repository does not vendor that source or patch.

The recorded changes cover retained logs, unique log names, combined MakeMKV diagnostics, exact nonempty output installation without replacement, propagated failures, and finite dashboard log viewing. The retained evidence at `/srv/b70-encode/evidence/20260910-arm-implementation/` reports 18 focused passing tests. Those tests do not establish full application, real-disc, browser, or GPU acceptance.

Decision, 2026-09-11: the operator requested a boring, normal Docker deployment. Use stock upstream ARM 2.24.3, pinned by image digest in compose.yaml. This supersedes the earlier proposal to build a custom patched image. The local patches remain archived in the appliance workspace and are not applied to this deployment. Their 18 passing tests do not validate the stock image. Retain the prior review findings as live acceptance concerns; prefer upstream configuration and minimize ongoing custom maintenance.

Historical appliance references: `CURRENT_STATE.md`, `docs/arm-code-review-20260910.md`, and `docs/runbooks/arm-replacement-trial.md` in `/srv/b70-encode`. Preserve these records when moving future application documentation here.
