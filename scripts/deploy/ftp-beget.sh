#!/usr/bin/env bash
# Deploy adev production build to Beget FTP.
# Preserves/uploads .htaccess and dereferences bazel symlinks before upload.
#
# Usage:
#   # from repo root, with .env containing FTP_USER and FTP_PASSWORD
#   set -a && source .env && set +a
#   ./scripts/deploy/ftp-beget.sh
#
# Optional env:
#   FTP_HOST=catahagh.beget.tech
#   FTP_REMOTE_DIR=angular-docs/public_html
#   FTP_LOCAL_DIR=dist/bin/adev/dist/browser

set -euo pipefail

FTP_HOST="${FTP_HOST:-catahagh.beget.tech}"
FTP_REMOTE_DIR="${FTP_REMOTE_DIR:-angular-docs/public_html}"
FTP_LOCAL_DIR="${FTP_LOCAL_DIR:-dist/bin/adev/dist/browser}"
STAGING_DIR="${STAGING_DIR:-/tmp/adev-browser-deploy}"
BACKUP_DIR="${BACKUP_DIR:-/tmp/angular-docs-ftp-backup}"
NETRC_FILE="${NETRC_FILE:-/tmp/.adev-ftp.netrc}"

if [[ -z "${FTP_USER:-}" || -z "${FTP_PASSWORD:-}" ]]; then
  echo "ERROR: FTP_USER and FTP_PASSWORD must be set (e.g. via .env)" >&2
  exit 1
fi

if [[ ! -f "${FTP_LOCAL_DIR}/index.html" ]]; then
  echo "ERROR: missing ${FTP_LOCAL_DIR}/index.html — build first:" >&2
  echo "  pnpm exec bazel build //adev:build.production --config=snapshot-build" >&2
  exit 1
fi

if ! grep -q 'base href="/"' "${FTP_LOCAL_DIR}/index.html"; then
  echo "ERROR: index.html base href is not /" >&2
  exit 1
fi

echo "==> Stage dereferenced copy (bazel output contains many symlinks)"
rm -rf "${STAGING_DIR}"
mkdir -p "${STAGING_DIR}"
cp -aL "${FTP_LOCAL_DIR}/." "${STAGING_DIR}/"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HTACCESS_SRC="${HTACCESS_SRC:-${REPO_ROOT}/.htaccess}"
if [[ -f "${HTACCESS_SRC}" ]]; then
  cp -f "${HTACCESS_SRC}" "${STAGING_DIR}/.htaccess"
  echo "    copied ${HTACCESS_SRC} into staging"
elif [[ ! -f "${STAGING_DIR}/.htaccess" ]]; then
  echo "ERROR: missing ${HTACCESS_SRC} and no .htaccess in build output" >&2
  exit 1
fi

echo "    staged files: $(find "${STAGING_DIR}" -type f | wc -l), symlinks: $(find "${STAGING_DIR}" -type l | wc -l)"

# netrc avoids shell-metacharacter issues with passwords
umask 077
cat > "${NETRC_FILE}" <<EOF
machine ${FTP_HOST}
login ${FTP_USER}
password ${FTP_PASSWORD}
EOF

cleanup() { rm -f "${NETRC_FILE}"; }
trap cleanup EXIT

mkdir -p "${BACKUP_DIR}"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"

echo "==> Probe FTP connectivity"
if ! curl -sS --connect-timeout 15 --max-time 30 --netrc-file "${NETRC_FILE}" \
  "ftp://${FTP_HOST}/${FTP_REMOTE_DIR}/" -o /dev/null; then
  echo "ERROR: cannot reach ftp://${FTP_HOST}/ (Connection refused/timeout)." >&2
  echo "Beget often blocks datacenter IPs. Run this script from your local PC/VPN," >&2
  echo "or whitelist this machine IP in Beget panel." >&2
  exit 1
fi

echo "==> Backup remote .htaccess / index.html"
# Use netrc via temporary HOME
HOME_DIR="$(mktemp -d)"
cp "${NETRC_FILE}" "${HOME_DIR}/.netrc"
chmod 600 "${HOME_DIR}/.netrc"

HOME="${HOME_DIR}" lftp <<EOF
set ftp:ssl-allow no
set net:timeout 30
set net:max-retries 3
open ftp://${FTP_HOST}
cd ${FTP_REMOTE_DIR}
get -e .htaccess -o ${BACKUP_DIR}/htaccess.${TIMESTAMP} || echo "no remote .htaccess"
get -e index.html -o ${BACKUP_DIR}/index.html.${TIMESTAMP} || echo "no remote index.html"
bye
EOF

echo "==> Upload (mirror --delete, keep uploading our .htaccess)"
HOME="${HOME_DIR}" lftp <<EOF
set ftp:ssl-allow no
set net:timeout 60
set net:max-retries 5
set mirror:parallel-transfer-count 2
set ftp:passive-mode on
open ftp://${FTP_HOST}
cd ${FTP_REMOTE_DIR}
lcd ${STAGING_DIR}
mirror -R --verbose --delete \
  --no-perms \
  --exclude '^\.user\.ini$' \
  --exclude '^cgi-bin/'
bye
EOF

echo "==> Verify remote files"
HOME="${HOME_DIR}" lftp <<EOF
set ftp:ssl-allow no
open ftp://${FTP_HOST}
cd ${FTP_REMOTE_DIR}
cls -l index.html .htaccess
bye
EOF

rm -rf "${HOME_DIR}"
echo "Done. Backups in ${BACKUP_DIR}"
echo "Check: https://angular-docs.ru/ and a deep link e.g. /guide/signals"
