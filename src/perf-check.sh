#!/usr/bin/env bash
# Performance Diagnosis Toolkit v0.1
set -euo pipefail

# --- HTML report path ------------------------
RPT="/tmp/perf-$(date +%Y%m%d_%H%M%S).html"
# Start HTML file with header
cat > "$RPT" <<'EOF'
<html><head><title>Perf Report</title>
<style>body{font-family:monospace;white-space:pre}</style>
</head><body>
EOF

# --- Color Variables for Terminal Output -----
RED=$'\e[31m'
GRN=$'\e[32m'
YLW=$'\e[33m'
NRM=$'\e[0m'

# === CPU Usage Section ========================
{
  echo "<pre>"
  echo "=== Performance Analysis ==="
  echo
  echo "Top CPU processes:"
  ps aux --sort=-%cpu | head -10
  echo "</pre>"
} >> "$RPT"

echo "=== Performance Analysis ==="
echo
echo "Top CPU processes:"
ps aux --sort=-%cpu | head -10

# === CPU Load Alert Section ===================
load1=$(cut -d' ' -f1 /proc/loadavg)
cpu_count=$(nproc)

{
  echo "<pre>"
  echo "CPU Load Alert:"
  if (( $(echo "$load1 > $cpu_count * 0.8" | bc -l) )); then
    echo "High load: $load1"
  else
    echo "Load OK: $load1"
  fi
  echo "</pre>"
} >> "$RPT"

if (( $(echo "$load1 > $cpu_count * 0.8" | bc -l) )); then
  echo -e "${RED}High load: $load1${NRM}"
else
  echo -e "${GRN}Load OK: $load1${NRM}"
fi

# === Disk Usage Summary =======================
{
  echo "<pre>"
  echo "---- Disk Usage ----"
  df --output=pcent,target | tail -n +2 | sort -nr
  echo "</pre>"
} >> "$RPT"

echo -e "${YLW}---- Disk Usage ----${NRM}"
df --output=pcent,target | tail -n +2 | sort -nr

# === Load Classification ======================
{
  echo "<pre>"
  if (( $(echo "$load1 < 1.0" | bc -l) )); then
    echo "Load classification: 🟢 Normal"
  elif (( $(echo "$load1 < 2.0" | bc -l) )); then
    echo "Load classification: 🟡 Moderate"
  else
    echo "Load classification: 🔴 High"
  fi
  echo "</pre>"
} >> "$RPT"

if (( $(echo "$load1 < 1.0" | bc -l) )); then
  echo "Load classification: 🟢 Normal"
elif (( $(echo "$load1 < 2.0" | bc -l) )); then
  echo "Load classification: 🟡 Moderate"
else
  echo "Load classification: 🔴 High"
fi

# === Finish HTML File ==========================
cat >> "$RPT" <<'EOF'
</body></html>
EOF

echo "Report saved to: $RPT"

