# Single-container XFCE desktop in-browser (noVNC) that
# downloads Playgroup on each start into tmpfs and runs it.
FROM ghcr.io/linuxserver/webtop:xfce

# Prep as root, then hand off to abc (webtop's default user)
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xdg-utils procps libfuse2 openjdk-21-jre \
    && rm -rf /var/lib/apt/lists/*

# Drop in bootstrap bits
COPY start-playgroup.sh /usr/local/bin/start-playgroup
COPY entrypoint-seed.sh /usr/local/bin/entrypoint-seed
COPY bootstrap.desktop /defaults/autostart/playgroup-bootstrap.desktop
RUN chmod +x /usr/local/bin/start-playgroup /usr/local/bin/entrypoint-seed

# Back to normal user
USER abc

# Seed XFCE + launch webtop
ENTRYPOINT ["/usr/local/bin/entrypoint-seed"]
