# Browser-based XFCE desktop (noVNC) that downloads Playgroup on boot
FROM linuxserver/webtop:ubuntu-xfce

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xdg-utils procps libfuse2 openjdk-21-jre \
    && rm -rf /var/lib/apt/lists/*

# Runtime launcher (runs inside the XFCE session via .desktop)
COPY start-playgroup.sh /usr/local/bin/start-playgroup
RUN chmod +x /usr/local/bin/start-playgroup

# System-wide autostart (avoids writing into /config)
# XFCE/desktop envs read /etc/xdg/autostart automatically
COPY bootstrap.desktop /etc/xdg/autostart/playgroup-bootstrap.desktop

# Root-privileged init hook: clear the app cache volume each boot
# and make sure it's owned by the abc user so the session can write
COPY entrypoint-seed.sh /custom-cont-init.d/10-playgroup-appcache
RUN chmod +x /custom-cont-init.d/10-playgroup-appcache

# Keep LinuxServer's default entrypoint (/init with s6-overlay)
# and default runtime user switching (PUID/PGID)
