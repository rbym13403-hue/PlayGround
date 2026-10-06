#!/usr/bin/env bash
set -euo pipefail
time -p cd "$(dirname "$0")"
export PROJECT_ROOT="$(pwd)"
export PORT="${PORT:-3000}"
export WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p dist
/usr/bin/time -p cp -f index.html dist/index.html
/usr/bin/time -p test -f dist/index.html
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p bash -c 'printf "{\"project\":\"%s\",\"directory\":\"%s/dist\"}" "$PROJECT_ROOT" "$PROJECT_ROOT" > "$WEB_DIR/deployment-output.json"'
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
/usr/bin/time -p node -e 'const fs=require("fs"),path=require("path");const j=JSON.parse(fs.readFileSync(process.env.WEB_DIR+"/deployment-output.json","utf8"));if(!fs.existsSync(path.join(j.directory,"index.html")))throw new Error("dist missing index.html");console.log("verified "+j.directory)'
exec /usr/bin/time -p node -e '
const { readFileSync, statSync, existsSync } = require("fs");
const { resolve, join, extname } = require("path");
const { createServer } = require("http");
const root = join(process.env.PROJECT_ROOT, "dist");
if (!existsSync(join(root, "index.html"))) { console.error("missing dist/index.html"); process.exit(1); }
const mime = {".html":"text/html",".js":"application/javascript",".css":"text/css",".json":"application/json",".svg":"image/svg+xml",".png":"image/png",".jpg":"image/jpeg",".webp":"image/webp"};
const server = createServer((req, res) => {
  try {
    const url = new URL(req.url, "http://localhost");
    let p = resolve(root, "." + decodeURIComponent(url.pathname));
    if (p !== resolve(root) && !p.startsWith(resolve(root) + "/")) { res.writeHead(404); res.end(); return; }
    try { if (statSync(p).isDirectory()) p = join(p, "index.html"); } catch { p = join(root, "index.html"); }
    res.setHeader("Content-Type", mime[extname(p)] || "application/octet-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.end(readFileSync(p));
  } catch (e) { res.writeHead(404); res.end("Not found"); }
});
const port = Number(process.env.PORT || 3000);
server.listen(port, "0.0.0.0", () => console.log("serving " + root + " on :" + port));
'
