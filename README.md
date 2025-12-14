# Linux Server Deployment Pipeline

This repository documents a Linux server and deployment pipeline built as part of my studies.  
The project focuses on **real-world server setup, automation, containerization, monitoring, and deployment** using AWS EC2 and common production tools.

The goal was to design and implement a small but realistic production environment from scratch.

---

## Project Overview

The project includes:

- Provisioning and securing an **AWS EC2 instance**
- Automated server configuration using **Bash**
- Containerized deployment using **Docker & Docker Compose**
- Reverse proxy setup using **NGINX**
- Process management and API deployment
- **Scheduled backups and health monitoring**
- Logging and operational structure
- PostgreSQL database integration

The entire setup was implemented, tested, and verified to work in practice.

---

## Architecture & Pipeline

High-level flow:

1. AWS EC2 instance (free-tier)
2. Secure access via SSH keys
3. Automated server configuration scripts
4. Application deployed as Docker containers
5. Reverse proxy via NGINX
6. PostgreSQL database
7. Scheduled backups and monitoring
8. Logs and alerts for operational insight

---

## Technologies Used

- **AWS EC2** (Infrastructure)
- **Linux / Bash** (Server configuration & automation)
- **Docker & Docker Compose** (Containerization)
- **NGINX** (Reverse proxy)
- **Python** (API / application logic)
- **PostgreSQL** (Database)
- **CRON** (Scheduled tasks)
- **Git & GitHub** (Version control and documentation)

---

## Repository Structure

```text
linux-server/
├── app/                # Application source
├── scripts/            # Bash scripts for setup, backups, monitoring
├── logs/               # Application and system logs
├── backups/            # Scheduled backup output
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── main.py
├── requirements.txt
```

## Infrastructure Status

The EC2 instance used for this project is currently **stopped** to avoid unnecessary cloud costs.
The infrastructure and configuration can be recreated at any time using the scripts and setup described in this repository.

└── README.md

