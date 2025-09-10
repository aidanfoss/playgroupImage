# One-container XFCE desktop (noVNC) that downloads Playgroup on boot
FROM linuxserver/webtop:ubuntu-xfce

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xdg-utils procps libfuse2 openjdk-21-jre \
    && rm -rf /var/lib/apt/lists/*

COPY start-playgroup.sh /usr/local/bin/start-playgroup
COPY entrypoint-seed.sh /usr/local/bin/entrypoint-seed
# ⬇️ use our own defaults dir; /defaults doesn't exist on this base image
RUN mkdir -p /opt/defaults/autostart
COPY bootstrap.desktop /opt/defaults/autostart/playgroup-bootstrap.desktop
RUN chmod +x /usr/local/bin/start-playgroup /usr/local/bin/entrypoint-seed

USER abc
ENTRYPOINT ["/usr/local/bin/entrypoint-seed"]
