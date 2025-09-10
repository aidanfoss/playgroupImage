#!/usr/bin/with-contenv bash
set -euo pipefail
# runs as root before services start

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

APP_CACHE="/opt/app-cache"
mkdir -p "${APP_CACHE}"

# Wipe on every container boot (your “erase on boot” requirement)
rm -rf "${APP_CACHE:?}/"* || true

# Ensure ownership for the runtime user
chown -R "${PUID}:${PGID}" "${APP_CACHE}"
chmod -R u+rwX,g+rwX "${APP_CACHE}"
