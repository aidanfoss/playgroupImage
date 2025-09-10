# playgroup-one

Single-container **browser desktop** (XFCE + noVNC) that **downloads Playgroup at boot into RAM** and auto-launches it. Paste the URL into a Tabletop Simulator tablet and you're in.

## Quick start (Docker Compose)
```bash
cp .env.example .env
# edit .env: set PASSWORD and PLAYGROUP_URL (and optional SHA256)
docker compose up -d --build
