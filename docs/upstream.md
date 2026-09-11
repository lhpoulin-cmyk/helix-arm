# Upstream and local changes

Upstream project: https://github.com/automatic-ripping-machine/automatic-ripping-machine

The existing appliance record identifies release 2.24.3 at commit `8c140c88919f2d5230dc828c56051f727eb8d50a`, with dependency submodule `3a04c4d4bed76458d09361ba4878bf72c1711f50`. These are staged provenance records, not a claim about the latest upstream release.

The complete two-commit reliability patch series and its 18 focused tests are now tracked in [patches/arm](../patches/arm/README.md), with the upstream license. Apply it to the pinned base to reproduce the source tree. [Source changes](source-changes.md) inventories all ten changed files; [historical review](source-review.md) preserves the original findings.

Original commits: `06079d83d4db455dc9d04d54438cafee0892251e` and `f1ee2081352c51d90875acfdb868ea6ade54b232`. Mailbox author headers are sanitized to the repository maintainer identity; applying the patch reproduces the exact original source tree, while resulting commit IDs differ.

The latest operator instruction supersedes the earlier stock-image choice: a custom Docker image containing these patches is required. Image creation and live validation remain pending. Compose now requires an explicit custom-image reference rather than silently using stock ARM. See [custom-image work](custom-image.md).

The original appliance checkout and evidence remain preserved. No source media or running application was changed by this import.
