#!/usr/bin/env bash
set -euo pipefail

CFG_DIR="/config/.config/xfce4/xfconf/xfce-perchannel-xml"
if [ ! -f "${CFG_DIR}/xfwm4.xml" ]; then
  mkdir -p "${CFG_DIR}"
  cat > "${CFG_DIR}/xfwm4.xml" <<'XML'
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

AS_DIR="/config/.config/autostart"
mkdir -p "${AS_DIR}"
cp -f /opt/defaults/autostart/playgroup-bootstrap.desktop \
      "${AS_DIR}/playgroup-bootstrap.desktop" || true

exec /init
