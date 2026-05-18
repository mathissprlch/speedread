#!/usr/bin/env bash
# launch.sh — build a self-contained RSVP HTML with the text embedded and open it.
# Usage: launch.sh <text-file> [wpm]
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$DIR/reader.html"
INPUT="${1:-}"
WPM="${2:-450}"

if [ -z "$INPUT" ] || [ ! -r "$INPUT" ]; then
  echo "Usage: $0 <text-file> [wpm]" >&2
  exit 1
fi
if [ ! -r "$TEMPLATE" ]; then
  echo "Reader template not found: $TEMPLATE" >&2
  exit 1
fi

TMP="${TMPDIR:-/tmp}/speedread-$(date +%s).html"

TEMPLATE="$TEMPLATE" INPUT="$INPUT" OUT="$TMP" WPM="$WPM" node -e '
const fs = require("fs");
const tmpl = process.env.TEMPLATE;
const input = process.env.INPUT;
const out = process.env.OUT;
const wpm = parseInt(process.env.WPM, 10) || 450;
const html = fs.readFileSync(tmpl, "utf8");
const text = fs.readFileSync(input, "utf8");
const inject = `<script>window.RSVP_EMBEDDED = { text: ${JSON.stringify(text)}, wpm: ${wpm}, autostart: true, smartMd: true };</script>\n`;
const result = html.replace(/(<script>\s*\n\s*\(function)/, inject + "$1");
if (result === html) {
  console.error("Failed to inject — main <script>(function block not found in reader template");
  process.exit(2);
}
fs.writeFileSync(out, result);
'

if command -v open >/dev/null 2>&1; then
  open "$TMP"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$TMP"
fi

echo "$TMP"
