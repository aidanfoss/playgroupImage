#!/usr/bin/with-contenv bash
set -euo pipefail
APP_CACHE="/opt/app-cache"
mkdir -p "${APP_CACHE}"
rm -rf "${APP_CACHE:?}/"* || true
# Ownership not needed if /config is tmpfs/local; webtop will run as PUID/PGID
