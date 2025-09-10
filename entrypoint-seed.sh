#!/usr/bin/with-contenv bash
set -euo pipefail

# PUID/PGID are provided by LinuxServer env (defaults 1000/1000 if unset)
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

CFG_ROOT="/config/.config"
XFCONF_DIR="${CFG_ROOT}/xfce4/xfconf/xfce-perchannel-xml"
AUTOSTART_DIR="${CFG_ROOT}/autostart"

# Ensure /config exists and is writable, fix ownership
mkdir -p /config
chown -R "${PUID}:${PGID}" /config || true
chmod -R u+rwX,g+rwX /config || true

# Create required dirs
mkdir -p "${XFCONF_DIR}" "${AUTOSTART_DIR}"

# Seed XFCE low-lag settings if missing
if [ ! -f "${XFCONF_DIR}/xfwm4.xml" ]; then
  cat > "${XFCONF_DIR}/xfwm4.xml" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
    <property name="cycle_preview" type="bool" value="false"/>
    <property name="box_move" type="bool" value="true"/>
    <property name="box_resize" type="bool" value="true"/>
  </property>
</channel>
XML
fi

# Install our autostart .desktop
cp -f /opt/defaults/autostart/playgroup-bootstrap.desktop \
      "${AUTOSTART_DIR}/playgroup-bootstrap.desktop"

# Final ownership to the mapped user
chown -R "${PUID}:${PGID}" /config
