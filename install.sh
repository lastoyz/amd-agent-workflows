#!/usr/bin/env bash
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)/skills"
for dst_root in "$HOME/.cursor/skills" "$HOME/.claude/skills"; do
  mkdir -p "$dst_root"
  for d in "$src"/*/; do
    name="$(basename "$d")"
    rm -rf "$dst_root/$name"
    cp -R "$d" "$dst_root/$name"
    echo "installed $name -> $dst_root/$name"
  done
done
echo "Done. Restart Cursor / Claude Code so skills reload."
