# ARM reliability patch series

This mailbox contains both source-fix commits and all 18 focused tests. It is the complete implementation, not only a description. Upstream ARM remains a pinned dependency rather than a copied full repository.

Base: ARM 2.24.3, `8c140c88919f2d5230dc828c56051f727eb8d50a`.
Dependency submodule: `3a04c4d4bed76458d09361ba4878bf72c1711f50`.
Expected resulting source tree: `9a8c6b01166ed64f3c85fbc76822bce0e59a30b1`.

From a clean checkout of that base, apply the absolute path to this repository's patch:

```bash
git am /absolute/path/to/helix-arm/patches/arm/0001-reliable-ingest.patch
python3 -m unittest discover -s test/local -v
git rev-parse 'HEAD^{tree}'
```

Use a separate checkout; preserve existing source and evidence. Python 3, Jinja2 and Node are needed for the focused suite. Tests load exact source definitions without triggering ARM's Flask/database/device initialization; real subprocess and temporary-file tests supplement mocks. They do not certify the entire application.

Original source commits are recorded in [upstream notes](../../docs/upstream.md). Author headers were sanitized without changing source hunks. The upstream MIT license is retained in `LICENSE.upstream`.

Fresh replay on 2026-09-11 produced the exact expected tree; 18 tests, Python compilation, shell syntax, and patch whitespace checks passed. Raw evidence remains outside Git at `/srv/b70-encode/evidence/20260911-helix-arm-source-import/`.

See [source inventory](../../docs/source-changes.md) for behavior and constraints. A [custom image](../../docs/custom-image.md) must be created before deployment. Rollback is to leave this checkout unused or restore a previously validated image/configuration/database together, retaining all media and logs. Stock ARM is a diagnostic baseline, not an equivalent replacement for these fixes.
