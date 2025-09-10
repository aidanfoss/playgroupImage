#!/usr/bin/env bash
set -euo pipefail
APP_DIR="/opt/app-cache"
BIN_PATH="${APP_DIR}/Playgroup.AppImage"
URL="${PLAYGROUP_URL:-}"
EXPECTED_SHA="${PLAYGROUP_SHA256:-}"

mkdir -p "${APP_DIR}"
if [[ -z "$URL" ]]; then
  notify-send 'Playgroup' 'PLAYGROUP_URL is not set' || true
  exit 0
fi
curl -fL --retry 5 --retry-delay 2 --continue-at - -o "${BIN_PATH}.part" "$URL"
mv "${BIN_PATH}.part" "${BIN_PATH}"
chmod +x "${BIN_PATH}"
if [[ -n "$EXPECTED_SHA" ]]; then
  echo "${EXPECTED_SHA}  ${BIN_PATH}" | sha256sum -c - || { rm -f "${BIN_PATH}"; exit 1; }
fi
setsid bash -lc "\"${BIN_PATH}\" --no-sandbox" >/dev/null 2>&1 &
