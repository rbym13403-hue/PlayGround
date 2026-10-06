#!/usr/bin/env bash
set -euo pipefail
time -p cd "$(dirname "$0")"
export CAPTURE_URL="${CAPTURE_URL:?Set CAPTURE_URL.}"
export CAPTURE_DIR="${CAPTURE_DIR:?Set CAPTURE_DIR.}"
export RUNTIME_DIR="${RUNTIME_DIR:?Set RUNTIME_DIR.}"
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p bash -c 'echo "capturing $CAPTURE_URL -> $CAPTURE_DIR"'
set +e
/usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
status=$?
set -e
/usr/bin/time -p ls -la "$CAPTURE_DIR"
/usr/bin/time -p test -f "$CAPTURE_DIR/final-desktop.png"
/usr/bin/time -p test -f "$CAPTURE_DIR/final-mobile.png"
exit "$status"
