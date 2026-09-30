#!/bin/zsh
set -euo pipefail

source_video="${1:-}"
project_name="${2:-}"
if [[ -z "$source_video" || ! -f "$source_video" ]]; then
  print -u2 "Usage: create-project.sh <source-video> [project-name]"
  exit 2
fi
if ! command -v ffprobe >/dev/null 2>&1; then
  print -u2 "ERROR: ffprobe is required."
  exit 3
fi

if [[ -z "$project_name" ]]; then
  project_name="$(basename "$source_video")"
  project_name="${project_name%.*}"
fi
safe_name="$(print -r -- "$project_name" | tr ' /:' '---' | tr -cd '[:alnum:]_.-')"
[[ -n "$safe_name" ]] || safe_name="tiktok-edit"
stamp="$(date '+%Y%m%d-%H%M%S')"
project_dir="${TIKTOK_EDITS_DIR:-$HOME/Movies/TikTok Edits}/${stamp}-${safe_name}"

mkdir -p "$project_dir"/{source,transcript,broll,work,exports,review}
cp -p "$source_video" "$project_dir/source/input.${source_video##*.}"
ffprobe -v error -show_streams -show_format -of json "$source_video" > "$project_dir/source/probe.json"
print -r -- "$source_video" > "$project_dir/source/origin.txt"
print -r -- "$project_dir"
