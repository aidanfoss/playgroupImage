# 00-fix-perms.sh
#!/usr/bin/with-contenv bash
set -euo pipefail
PUID="${PUID:-1000}"; PGID="${PGID:-1000}"
for d in /config /opt/app-cache; do
  [ -d "$d" ] || continue
  chown -R "$PUID:$PGID" "$d" || true
  chmod -R u+rwX,g+rwX "$d"   || true
done
