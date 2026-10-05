#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
PROJECT_DIR="$PWD"
DIST_DIR="$PROJECT_DIR/dist"
PORT="${PORT:-3000}"
META_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p test -f "$DIST_DIR/index.html"
/usr/bin/time -p mkdir -p "$META_DIR"
if /usr/bin/time -p test -f "$PROJECT_DIR/package.json"; then
  /usr/bin/time -p npm install --no-audit --no-fund
  if /usr/bin/time -p bash -c 'node -e "const p=require(\"./package.json\");process.exit(p.scripts&&p.scripts.build?0:1)"'; then
    /usr/bin/time -p npm run build
  fi
fi
/usr/bin/time -p printf '{"project":"%s","directory":"%s"}' "$PROJECT_DIR" "$DIST_DIR" > "$META_DIR/deployment-output.json"
/usr/bin/time -p cat "$META_DIR/deployment-output.json"
/usr/bin/time -p python3 --version
exec /usr/bin/time -p python3 -m http.server "$PORT" --directory "$DIST_DIR"
