#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
PROJECT_DIR="$PWD"
/usr/bin/time -p bash -c 'test -n "${CAPTURE_URL:-}" || { echo "Set CAPTURE_URL." >&2; exit 1; }'
/usr/bin/time -p bash -c 'test -n "${CAPTURE_DIR:-}" || { echo "Set CAPTURE_DIR." >&2; exit 1; }'
/usr/bin/time -p bash -c 'test -n "${RUNTIME_DIR:-}" || { echo "Set RUNTIME_DIR." >&2; exit 1; }'
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p bash -c 'case "$1/" in "$2/"*) echo "CAPTURE_DIR must stay outside source." >&2; exit 1;; esac' _ "$CAPTURE_DIR" "$PROJECT_DIR"
/usr/bin/time -p test -f "$RUNTIME_DIR/scripts/default-capture.mjs"
/usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
status=$?
/usr/bin/time -p test -s "$CAPTURE_DIR/final-desktop.png"
/usr/bin/time -p test -s "$CAPTURE_DIR/final-mobile.png"
/usr/bin/time -p ls -lh "$CAPTURE_DIR/final-desktop.png" "$CAPTURE_DIR/final-mobile.png"
exit $status
