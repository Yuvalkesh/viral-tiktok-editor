# Viral TikTok Editor

A free agent skill that edits talking-head recordings into TikTok, Instagram Reels and YouTube Shorts.

You record yourself talking. The agent transcribes it, finds the strongest opening, cuts the dead air and retakes, adds accurate captions (built for Hebrew and right-to-left text, works for any language), inserts relevant B-roll, mixes quiet music under your voice, and exports a 1080x1920 MP4. If you want to keep editing by hand, it can also hand off an editable CapCut project.

Built and used by [Yuval Keshtcher](https://yuvkesh.onrender.com/blog/edit-videos-with-gpt-6-astra/) with OpenAI Codex running GPT-6 Astra. The same folder works as a Claude Code skill.

## What it does

1. Creates a new project folder per video and never touches the original recording.
2. Transcribes locally with whisper.cpp (word timestamps, no upload).
3. Writes an edit plan: hook, cuts, punch-in zooms, B-roll beats, audio cues.
4. Sources B-roll in a strict order: your own footage and screenshots first, then official sources, then licensed stock, and generated images only as illustration, never as proof. Every insert is logged in `broll/sources.tsv`.
5. Builds one frame-accurate timeline JSON that drives video, dialogue and captions, so nothing drifts.
6. Cleans dialogue conservatively, ducks music under speech, targets about -16 to -14 LUFS.
7. Renders, then checks frames, captions, loudness and decode before calling it done.
8. Versions every export (`final-v01.mp4`, `final-v02.mp4`...). Never overwrites. Never publishes.

## Install

**Codex**

```sh
git clone https://github.com/Yuvalkesh/viral-tiktok-editor ~/.codex/skills/viral-tiktok-editor
```

**Claude Code**

```sh
git clone https://github.com/Yuvalkesh/viral-tiktok-editor ~/.claude/skills/viral-tiktok-editor
```

Then ask your agent: `Use $viral-tiktok-editor to edit my latest recording for TikTok.`

## Requirements

- macOS or Linux
- `ffmpeg`, `ffprobe`, `jq`
- [whisper.cpp](https://github.com/ggerganov/whisper.cpp) (`whisper-cli` on your PATH)
- A Whisper model. The skill is tuned for `ggml-large-v3-turbo-q5_0.bin` (checksum in `references/hebrew-production.md`)
- Optional: CapCut desktop for the editable project handoff; Python with Pillow + RAQM if your FFmpeg has no libass

## Settings

| Variable | Default | What it controls |
|---|---|---|
| `TIKTOK_EDITS_DIR` | `~/Movies/TikTok Edits` | Where project folders are created |
| `TIKTOK_SOURCE_DIR` | `~/Movies` | Where to look for the newest recording |
| `WHISPER_MODEL` | `~/whisper-models/ggml-large-v3-turbo-q5_0.bin` | Transcription model |
| `WHISPER_LANGUAGE` | `he` | Set to `en` (or any code) for other languages |

## Make it yours

The skill gets better the more you feed it:

- **References.** Point it at a creator or a video whose style you like. It studies pacing, framing and captions and writes down what it learned.
- **Feedback.** After each edit, tell it what felt wrong ("fewer diagrams, more real footage"). Add those notes to the reference files so the next edit starts smarter. `references/broll.md` already contains one such rule.
- **Extra footage.** Drop screenshots, screen recordings or product clips into the chat and tell it where they belong.

## Files

```
SKILL.md                     the workflow the agent follows
references/editorial.md      hook, pacing, zooms, caption rhythm
references/broll.md          sourcing rules and the sources manifest
references/hebrew-production.md  ASR, timeline math, RTL captions, audio mix
references/restoration.md    echo, noise and camera shake
references/capcut-handoff.md editable CapCut project
references/delivery.md       export spec and QA
scripts/create-project.sh    new project folder per video
scripts/transcribe.sh        local whisper.cpp transcription
scripts/captions_to_ass.py   SRT to styled ASS captions
scripts/qa-video.sh          basic export checks
```

## License

MIT
