#!/bin/zsh
set -euo pipefail

video="${1:-}"
if [[ -z "$video" || ! -f "$video" ]]; then
  print -u2 "Usage: qa-video.sh <final-video>"
  exit 2
fi

probe="$(ffprobe -v error -show_entries format=duration,size:stream=codec_type,codec_name,width,height,r_frame_rate,sample_rate,channels -of json "$video")"
print -r -- "$probe"
width="$(print -r -- "$probe" | jq -r '[.streams[] | select(.codec_type=="video")][0].width // 0')"
height="$(print -r -- "$probe" | jq -r '[.streams[] | select(.codec_type=="video")][0].height // 0')"
audio_count="$(print -r -- "$probe" | jq '[.streams[] | select(.codec_type=="audio")] | length')"
duration="$(print -r -- "$probe" | jq -r '.format.duration // 0')"

[[ "$width" == "1080" && "$height" == "1920" ]] || { print -u2 "FAIL: expected 1080x1920, got ${width}x${height}"; exit 3; }
[[ "$audio_count" -ge 1 ]] || { print -u2 "FAIL: no audio stream"; exit 4; }
awk -v d="$duration" 'BEGIN { exit !(d > 0) }' || { print -u2 "FAIL: invalid duration"; exit 5; }

ffmpeg -v error -i "$video" -f null -
print "PASS: decodes cleanly, 1080x1920, audio present, duration ${duration}s"
