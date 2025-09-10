#!/usr/bin/env bash
set -euo pipefail

# Runs inside XFCE session at login (autostart)
APP_DIR="/opt/app"
BIN_PATH="${APP_DIR}/Playgroup.AppImage"   # treat as AppImage/binary
URL="${PLAYGROUP_URL:-}"
EXPECTED_SHA="${PLAYGROUP_SHA256:-}"

mkdir -p "${APP_DIR}"

download() {
  if [[ -z "${URL}" ]]; then
    notify-send 'Playgroup' 'PLAYGROUP_URL is not set' || true
    exit 0
  fi
  echo "[playgroup] downloading ${URL} -> ${BIN_PATH}"
  curl -fL --retry 5 --retry-delay 2 --continue-at - -o "${BIN_PATH}.part" "${URL}"
  mv "${BIN_PATH}.part" "${BIN_PATH}"
  chmod +x "${BIN_PATH}"

  if [[ -n "${EXPECTED_SHA}" ]]; then
    echo "${EXPECTED_SHA}  ${BIN_PATH}" | sha256sum -c - || {
      echo "[playgroup] checksum mismatch!" >&2
      notify-send 'Playgroup' 'Checksum mismatch. Not starting.' || true
      rm -f "${BIN_PATH}"
      exit 1
    }
  fi
}

# Always fresh (tmpfs will be empty every start)
download

# Launch detached; add flags if Playgroup supports them
setsid bash -lc "\"${BIN_PATH}\" --no-sandbox" >/dev/null 2>&1 &
