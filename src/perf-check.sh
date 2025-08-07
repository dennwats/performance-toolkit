#!/usr/bin/env bash
#Performance Diagnosis Toolkit v0.1
set -euo pipefail

echo "=== Performance Analysis ==="

echo -e "\nTop CPU processes:"
ps aux --sort=-%cpu

