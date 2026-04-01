#!/usr/bin/env bash
set -euo pipefail

# =============================================================
# Daily Stock Analysis — Cron Wrapper
# Runs every weekday at 4:00 AM via crontab
# Sets proxy, activates uv, and executes the analysis pipeline
# =============================================================

# --- Proxy (must be set before any network call) ---
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"
export USE_PROXY=true
export NO_PROXY=registry.npm.taobao.org,localhost,127.0.0.1,0.0.0.0,::1,*.local,*.internal,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,dashscope.aliyuncs.com,*.aliyuncs.com,ark.cn-beijing.volces.com,.volces.com
# --- Paths ---
PROJECT_DIR="/home/frank/code/daily_stock_analysis"
export PATH="/home/frank/.local/bin:$PATH"

# --- Working directory ---
cd "$PROJECT_DIR"

# --- Ensure log directory exists ---
mkdir -p logs

# --- Run analysis ---
LOG_FILE="logs/cron_$(date +%Y%m%d).log"

echo "===== Cron run started at $(date '+%Y-%m-%d %H:%M:%S') =====" >> "$LOG_FILE"

uv run python main.py --stocks 300750,300308,601777,000989 --force-run >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

echo "===== Cron run ended at $(date '+%Y-%m-%d %H:%M:%S') (exit=$EXIT_CODE) =====" >> "$LOG_FILE"

exit $EXIT_CODE
