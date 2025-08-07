#!/usr/bin/env bash
#Performance Diagnosis Toolkit v0.1
set -euo pipefail

# --- Color helpers ------------------------------
RED="\e[31m"
GRN="\e[32m"
YLW="\e[33m"
NRM="\e[0m"

echo "=== Performance Analysis ==="

echo -e "\nTop CPU processes:"
ps aux --sort=-%cpu

load1=$(cut -d' ' -f1 /proc/loadavg)
cpu_count=$(nproc)

# CPU load alert
if (( $(echo "$load1 > $cpu_count * 0.8" | bc -l) )); then
    echo -e "${RED}High load: $load1${NRM}"
else
    echo -e "${GRN}Load OK: $load1${NRM}"
fi

# Disk usage summary
echo -e "${YLW}---- Disk Usage ----${NRM}"
df --output=pcent,target | tail -n +2 | sort -nr

# Load classification
if (( $(echo "$load1 < 1.0" | bc -l) )); then
    echo "Load classification: 🟢 Normal"
elif (( $(echo "$load1 < 2.0" | bc -l) )); then
    echo "Load classification: 🟡 Moderate"
else
    echo "Load classification: 🔴 High"
fi

