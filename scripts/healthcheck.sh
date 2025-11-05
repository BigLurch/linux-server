#!/usr/bin/env bash

LOCKFILE="/tmp/healthcheck.lock"

if [ -f "$LOCKFILE" ]; then
  echo "Healthcheck already running, exiting." >> /srv/apps/fastapi_app/logs/healthcheck.log
  exit 0
fi

trap "rm -f $LOCKFILE" EXIT
touch "$LOCKFILE"#!/usr/bin/env bash

set -euo pipefail

# --- Environment and paths ---
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV_FILE="/srv/apps/fastapi_app/.env"
DISCORD_WEBHOOK_URL=$(grep '^DISCORD_WEBHOOK_URL=' "$ENV_FILE" | cut -d '=' -f2 | tr -d '"')

# --- CPU and disk usage ---
CPU_STR=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU=${CPU_STR%.*}  # remove decimals
DISK=$(df -h / | awk 'NR==2 {gsub(/%/, ""); print $5}')

# --- Thresholds ---
CPU_LIMIT=85
DISK_LIMIT=90

# --- Alarm if CPU is too high ---
if (( CPU > CPU_LIMIT )); then
	/usr/bin/curl -sS -H "Content-Type: application/json" \
	-d "{\"content\": \"⚠️ High CPU usage detected: ${CPU}%\"}" \
	"$DISCORD_WEBHOOK_URL" >> /srv/apps/fastapi_app/logs/healthcheck-curl.log 2>&1
fi

# --- Alarm if disk is too high ---
if (( DISK > DISK_LIMIT )); then
	/usr/bin/curl -sS -H "Content-Type: application/json" \
	-d "{\"content\": \"⚠️ Disk usage high: ${DISK}% used\"}" \
	"$DISCORD_WEBHOOK_URL" >> /srv/apps/fastapi_app/logs/healthcheck-curl.log 2>&1
fi

# --- Daily check-in at 03:00 and 15:00 ---
HOUR=$(date '+%H')
MINUTE=$(date '+%M')
DATE=$(date '+%Y-%m-%d %H:%M')

if { [[ "$HOUR" -eq 3 ]] || [[ "$HOUR" -eq 15 ]]; } && [[ "$MINUTE" -eq 0 ]]; then
	/usr/bin/curl -sS -H "Content-Type: application/json" \
	-d "{\"content\": \"✅ Server check-in: All systems nominal. CPU ${CPU}%, Disk ${DISK}% on ${DATE}\"}" \
	"$DISCORD_WEBHOOK_URL" >> /srv/apps/fastapi_app/logs/healthcheck-curl.log 2>&1
fi
