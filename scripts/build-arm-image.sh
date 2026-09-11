#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  printf 'Usage: %s SOURCE_DIR BASE_IMAGE_AT_DIGEST\n' "$0" >&2
  printf 'Example base: automaticrippingmachine/arm-dependencies@sha256:<digest>\n' >&2
  exit 2
fi

source_dir="$(realpath "$1")"
base_image="$2"
image_tag="${HELIX_ARM_IMAGE_TAG:-helix-arm:2.24.3-reliable-ingest}"
readonly EXPECTED_TREE="9a8c6b01166ed64f3c85fbc76822bce0e59a30b1"

if [[ "${base_image}" != automaticrippingmachine/arm-dependencies@sha256:* ]]; then
  printf 'Base image must be pinned by digest, got: %s\n' "${base_image}" >&2
  exit 1
fi

actual_tree="$(git -C "${source_dir}" rev-parse 'HEAD^{tree}')"
if [[ "${actual_tree}" != "${EXPECTEDED_TREE:-$EXPECTED_TREE}" ]]; then
  printf 'Refusing unverified source tree: %s\n' "${actual_tree}" >&2
  exit 1
fi

dockerfile="$(mktemp)"
trap 'rm -f "${dockerfile}"' EXIT
sed "s|^FROM automaticrippingmachine/arm-dependencies:1.8.0 AS base$|FROM ${base_image} AS base|" \
  "${source_dir}/Dockerfile" > "${dockerfile}"

if ! grep -Fqx "FROM ${base_image} AS base" "${dockerfile}"; then
  printf 'Upstream Dockerfile base line did not match the expected 2.24.3 form.\n' >&2
  exit 1
fi

docker build \
  --file "${dockerfile}" \
  --label org.opencontainers.image.revision=8c140c88919f2d5230dc828c56051f727eb8d50a \
  --label io.helix-arm.patched-tree="${EXPECTED_TREE}" \
  --tag "${image_tag}" \
  "${source_dir}"

docker image inspect "${image_tag}" \
  --format 'image_id={{.Id}}\nrepo_digests={{json .RepoDigests}}\npatched_tree={{index .Config.Labels "io.helix-arm.patched-tree"}}'
