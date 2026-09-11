#!/usr/bin/env bash
set -euo pipefail

readonly UPSTREAM_URL="https://github.com/automatic-ripping-machine/automatic-ripping-machine.git"
readonly UPSTREAM_COMMIT="8c140c88919f2d5230dc828c56051f727eb8d50a"
readonly DEPENDENCY_COMMIT="3a04c4d4bed76458d09361ba4878bf72c1711f50"
readonly EXPECTED_TREE="9a8c6b01166ed64f3c85fbc76822bce0e59a30b1"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="${1:-${repo_root}/scratch/arm-patched}"
patch_file="${repo_root}/patches/arm/0001-reliable-ingest.patch"

if [[ -e "${source_dir}" ]]; then
  printf 'Refusing to replace existing path: %s\n' "${source_dir}" >&2
  exit 1
fi

git clone --no-checkout "${UPSTREAM_URL}" "${source_dir}"
git -C "${source_dir}" checkout --detach "${UPSTREAM_COMMIT}"
git -C "${source_dir}" submodule update --init --recursive

actual_dependency="$(git -C "${source_dir}/arm-dependencies" rev-parse HEAD)"
if [[ "${actual_dependency}" != "${DEPENDENCY_COMMIT}" ]]; then
  printf 'Unexpected dependency commit: %s\n' "${actual_dependency}" >&2
  exit 1
fi

git -C "${source_dir}" am "${patch_file}"
actual_tree="$(git -C "${source_dir}" rev-parse 'HEAD^{tree}')"
if [[ "${actual_tree}" != "${EXPECTED_TREE}" ]]; then
  printf 'Unexpected patched tree: %s\n' "${actual_tree}" >&2
  exit 1
fi

printf 'Prepared verified ARM source at %s\n' "${source_dir}"
printf 'Patched tree: %s\n' "${actual_tree}"
