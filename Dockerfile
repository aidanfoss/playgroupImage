# One-container XFCE desktop (noVNC) that downloads Playgroup on boot
FROM linuxserver/webtop:ubuntu-xfce

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xdg-utils procps libfuse2 openjdk-21-jre \
    && rm -rf /var/lib/apt/lists/*

# Runtime launcher (runs in user session)
COPY start-playgroup.sh /usr/local/bin/start-playgroup
RUN chmod +x /usr/local/bin/start-playgroup

# Ship our desktop file as a default we will copy into /config
RUN mkdir -p /opt/defaults/autostart
COPY bootstrap.desktop /opt/defaults/autostart/playgroup-bootstrap.desktop

# Root-privileged init hook: seeds /config and fixes ownership
# NOTE: /custom-cont-init.d scripts run as root before services start
COPY entrypoint-seed.sh /custom-cont-init.d/10-playgroup-seed
RUN chmod +x /custom-cont-init.d/10-playgroup-seed

# IMPORTANT: keep the image's default entrypoint (/init) so s6 + PUID/PGID work
# Do NOT override ENTRYPOINT
