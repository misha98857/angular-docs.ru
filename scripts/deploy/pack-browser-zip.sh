#!/usr/bin/env bash
# Pack adev production browser build into a deployable zip (real files + .htaccess).
#
# Usage (from repo root):
#   pnpm exec bazel build //adev:build.production --config=snapshot-build
#   ./scripts/deploy/pack-browser-zip.sh
#
# Output: dist/angular-docs-ru-browser.zip

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FTP_LOCAL_DIR="${FTP_LOCAL_DIR:-${REPO_ROOT}/dist/bin/adev/dist/browser}"
HTACCESS_SRC="${HTACCESS_SRC:-${REPO_ROOT}/.htaccess}"
STAGING_DIR="${STAGING_DIR:-/tmp/adev-browser-zip}"
ZIP_OUT="${ZIP_OUT:-${REPO_ROOT}/dist/angular-docs-ru-browser.zip}"

if [[ ! -f "${FTP_LOCAL_DIR}/index.html" ]]; then
  echo "ERROR: missing ${FTP_LOCAL_DIR}/index.html — build first:" >&2
  echo "  pnpm exec bazel build //adev:build.production --config=snapshot-build" >&2
  exit 1
fi

if [[ ! -f "${HTACCESS_SRC}" ]]; then
  echo "ERROR: missing ${HTACCESS_SRC}" >&2
  exit 1
fi

echo "==> Stage dereferenced browser build"
rm -rf "${STAGING_DIR}"
mkdir -p "${STAGING_DIR}"
cp -aL "${FTP_LOCAL_DIR}/." "${STAGING_DIR}/"
cp -f "${HTACCESS_SRC}" "${STAGING_DIR}/.htaccess"

if ! grep -q 'base href="/"' "${STAGING_DIR}/index.html"; then
  echo "ERROR: index.html base href is not /" >&2
  exit 1
fi

mkdir -p "$(dirname "${ZIP_OUT}")"
rm -f "${ZIP_OUT}"
(
  cd "${STAGING_DIR}"
  zip -qr "${ZIP_OUT}" .
)

echo "Done: ${ZIP_OUT}"
echo "    files: $(find "${STAGING_DIR}" -type f | wc -l), size: $(du -h "${ZIP_OUT}" | awk '{print $1}')"
echo "Extract into public_html (index.html and .htaccess at root)."
