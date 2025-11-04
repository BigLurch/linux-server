#!/bin/bash
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
tar -czf /srv/apps/fastapi_app/backups/backup_$TIMESTAMP.tar.gz /srv/apps/fastapi_app/logs
