# One-container XFCE desktop (noVNC) that downloads Playgroup on boot
# NOTE: use the LinuxServer registry at lscr.io
FROM linuxserver/webtop:ubuntu-xfce

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xdg-utils procps libfuse2 openjdk-21-jre \
    && rm -rf /var/lib/apt/lists/*

COPY start-playgroup.sh /usr/local/bin/start-playgroup
COPY entrypoint-seed.sh /usr/local/bin/entrypoint-seed
COPY bootstrap.desktop /defaults/autostart/playgroup-bootstrap.desktop
RUN chmod +x /usr/local/bin/start-playgroup /usr/local/bin/entrypoint-seed

USER abc
ENTRYPOINT ["/usr/local/bin/entrypoint-seed"]
