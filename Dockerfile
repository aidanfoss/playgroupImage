FROM linuxserver/webtop:ubuntu-xfce

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl xdg-utils procps libfuse2 openjdk-21-jre \
    && rm -rf /var/lib/apt/lists/*

COPY start-playgroup.sh /usr/local/bin/start-playgroup
RUN chmod +x /usr/local/bin/start-playgroup

# system-wide autostart; avoids per-user writes
COPY bootstrap.desktop /etc/xdg/autostart/playgroup-bootstrap.desktop

# clear app cache each boot (optional)
COPY entrypoint-seed.sh /custom-cont-init.d/10-playgroup-appcache
RUN chmod +x /custom-cont-init.d/10-playgroup-appcache
