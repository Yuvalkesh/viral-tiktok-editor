#!/bin/zsh
set -euo pipefail

project_dir="${1:-}"
model="${2:-${WHISPER_MODEL:-}}"
output_name="${3:-raw}"
if [[ -z "$project_dir" || ! -d "$project_dir/source" ]]; then
  print -u2 "Usage: transcribe.sh <project-dir> [whisper-model] [output-name]"
  exit 2
fi
if [[ -z "$model" ]]; then
  model="$HOME/whisper-models/ggml-large-v3-turbo-q5_0.bin"
  if [[ -f "$model" ]]; then
    model_hash="$(shasum -a 256 "$model")"
    [[ "${model_hash%% *}" == "394221709cd5ad1f40c46e6031ca61bce88931e6e088c188294c6d5a55ffa7e2" ]] || {
      print -u2 "ERROR: Installed default model failed checksum verification. Preserving it; pass another verified model."
      exit 3
    }
  fi
fi
if [[ -z "$model" || ! -f "$model" ]]; then
  print -u2 "ERROR: No Whisper model found. Pass its path or set WHISPER_MODEL. Ask before a new model download unless already authorized."
  exit 3
fi
[[ "$output_name" =~ '^[A-Za-z0-9][A-Za-z0-9_.-]*$' ]] || { print -u2 "ERROR: output-name must be a plain filename stem"; exit 2; }

inputs=("$project_dir"/source/input.*(N.))
[[ ${#inputs} -eq 1 ]] || { print -u2 "ERROR: expected exactly one source/input.*"; exit 4; }
input="${inputs[1]}"
wav="$project_dir/work/dialogue.wav"
out="$project_dir/transcript/$output_name"
for suffix in json srt txt; do
  [[ ! -e "$out.$suffix" ]] || { print -u2 "ERROR: $out.$suffix exists; choose a new output-name"; exit 5; }
done
mkdir -p "$project_dir/work" "$project_dir/transcript"

dtw="${WHISPER_DTW:-}"
if [[ -z "$dtw" ]]; then
  case "${model:t}" in
    *large-v3-turbo*) dtw="large.v3.turbo" ;;
    ggml-small.bin|ggml-small-q*.bin) dtw="small" ;;
  esac
fi
alignment_args=()
[[ -z "$dtw" || "$dtw" == none ]] || alignment_args=(-dtw "$dtw")

ffmpeg -y -v error -i "$input" -vn -ac 1 -ar 16000 -c:a pcm_s16le "$wav"
whisper-cli -m "$model" -f "$wav" -l "${WHISPER_LANGUAGE:-he}" -nfa "${alignment_args[@]}" -ojf -osrt -otxt -of "$out"
print "SRT=$out.srt"
print "JSON=$out.json"
print "TEXT=$out.txt"
