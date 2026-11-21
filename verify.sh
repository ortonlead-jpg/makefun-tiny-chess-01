#!/bin/bash
# Independent verification pass — run this, don't trust the builder agent's self-report.
set -e
cd "$(dirname "$0")"

SIZE=$(stat -c%s main.py)
echo "=== 1. Size check ==="
echo "main.py: $SIZE bytes (limit 4096)"
if [ "$SIZE" -gt 4096 ]; then
  echo "FAIL: over size limit by $((SIZE - 4096)) bytes"
else
  echo "PASS"
fi

echo ""
echo "=== 2. grade-local (fresh run) ==="
cd kit
node cli/makefun.mjs grade-local --kit . --bot .. --driver docker
