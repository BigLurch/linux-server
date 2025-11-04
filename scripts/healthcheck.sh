#!/usr/bin/env bash
set -euo pipefail

# Environment and paths
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# --- Fetch Discord-webhook ---
ENV_FILE="/srv/apps/fastapi_app/.env"
DISCORD_WEBHOOK_URL=$(grep '^DISCORD_WEBHOOK_URL=' "$ENV_FILE" | cut -d '=' -f2 | tr -d '"')

# --- CPU and disk ---
CPU_STR=$(/usr/bin/top -bn1 | /usr/bin/grep "Cpu(s)" | /usr/bin/awk '{print $2 + $4}')
CPU=${CPU_STR%.*}
DISK=$(/usr/bin/df -h / | /usr/bin/awk 'NR==2 {gsub(/%/,"",$5); print $5}')

CPU_LIMIT=85
DISK_LIMIT=90

# --- Alarm if CPU is to high ---
if (( CPU > CPU_LIMIT )); then
  /usr/bin/curl -sS -H "Content-Type: application/json" \
    -d "{\"content\":\"⚠️ High CPU usage detected: ${CPU}%\"}" \
    "$DISCORD_WEBHOOK_URL" >/srv/apps/fastapi_app/logs/healthcheck-curl.log 2>&1
fi

# --- Alarm if disk is to high ---
if (( DISK > DISK_LIMIT )); then
  /usr/bin/curl -sS -H "Content-Type: application/json" \
    -d "{\"content\":\"⚠️ Disk usage high: ${DISK}% used\"}" \
    "$DISCORD_WEBHOOK_URL" >/srv/apps/fastapi_app/logs/healthcheck-curl.log 2>&1
fi

# --- Daily check-in 03:00 ---
HOUR=$(/usr/bin/date +'%H')
DATE=$(/usr/bin/date +"%Y-%m-%d (%A) %H:%M")

if [ "$HOUR" -eq 03 ]; then
  /usr/bin/curl -sS -H "Content-Type: application/json" \
    -d "{\"content\":\"✅ Server check-in: All systems nominal. CPU ${CPU}%, Disk ${DISK}% on ${DATE}\"}" \
    "$DISCORD_WEBHOOK_URL" >/srv/apps/fastapi_app/logs/healthcheck-curl.log 2>&1
fi
