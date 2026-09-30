---
name: viral-tiktok-editor
description: "Edit talking-head recordings into TikTok, Instagram Reels, and Shorts with a stronger story, accurate Hebrew captions, relevant B-roll, balanced music, and an editable project. Use for video editing, shortening, captioning, or game-demo reels. Publishing is a separate task."
---

# Viral TikTok Editor

Produce a finished 1080x1920 MP4 and, when requested, a genuinely editable project opened in the editing app for review. Work non-destructively in a new project folder under `$TIKTOK_EDITS_DIR` (default `~/Movies/TikTok Edits`) and preserve the original recording. Prefer CapCut for the creator's manual review unless they choose another editor.

## Workflow

1. Resolve the requested source file. If none is named, use the newest video in `$TIKTOK_SOURCE_DIR` (default `~/Movies`), or the newest recording pulled from a connected phone, but show its filename and duration before editing.
2. Run `scripts/create-project.sh <source-video> [project-name]` and use the returned directory for every artifact.
3. Read [references/hebrew-production.md](references/hebrew-production.md) for local transcription, HDR sources, caption timing, RTL rendering, and audio. Run `scripts/transcribe.sh <project-dir> [whisper-model] [output-name]`. Reuse an installed, checksum-verified Whisper model; do not download it again. Correct names, brands, numbers, and punctuation against the supplied script or reliable sources.
4. Read [references/editorial.md](references/editorial.md), then create `edit-plan.md` and a reordered Hebrew script linked to actual source in/out points. Record the hook, deletions, timing, caption emphasis, punch-ins, transitions, B-roll beats, and audio cues. A rewritten script must remain achievable from the recorded speech; propose pickups separately if necessary.
5. Read [references/broll.md](references/broll.md) before searching or generating visuals. Save assets in `broll/` and create `broll/sources.tsv` with timing, source URL or `generated`, license/usage basis, and purpose.
6. Build one frame-aligned edit decision list or timeline JSON as the source of truth for video cuts, dialogue cuts, B-roll, and captions. Remap corrected source captions onto the edited timeline. `scripts/captions_to_ass.py` preserves cue timing by default; prepare phrase boundaries before conversion.
7. For echo, distant speech, or camera shake, read [references/restoration.md](references/restoration.md) and test restoration on the current recording before full rendering. Render with FFmpeg or the chosen editor. For editable CapCut delivery, read [references/capcut-handoff.md](references/capcut-handoff.md). Keep source trims, game inserts, dialogue, music, and text editable; importing the flattened MP4 alone does not fulfill this request.
8. Inspect representative frames and listen at the beginning, densest section, transitions, and ending. Fix errors before final export. If audio listening is unavailable, disclose that limit and separate it from successful decode/ASR/loudness checks.
9. Run `scripts/qa-video.sh <final-video>` and the checks in [references/delivery.md](references/delivery.md). Deliver versioned MP4, edit plan, corrected source transcript, edited SRT, source manifest, and requested native project. Open and verify the actual timeline when requested. Editing alone does not authorize upload or publication; explicit distribution follow-ups are covered in the delivery reference.

## Quality bar

- Start on the strongest spoken idea; remove setup, dead air, mistakes, repetitions, and weak tangents while preserving meaning.
- Default to fast but readable pacing. A visual change every 1.5–3.5 seconds is a starting point, not a quota; let speech, proof, and emotional pauses determine cuts.
- Keep the speaker visible for trust. B-roll normally lasts 0.8–3 seconds and should illustrate the exact claim being spoken.
- Captions must be accurate Hebrew, within title-safe margins, readable on a phone, and broken by spoken phrase rather than arbitrary character count.
- Use hard cuts and subtle zooms as the default. Reserve whooshes, flashes, and large transitions for real topic changes or punchlines.
- Prioritize a close, natural speaking voice. Loudness normalization and ordinary noise reduction do not remove room echo. Diagnose and treat reverberation separately when present; avoid metallic speech, pumping, and delayed parallel voice tracks. Keep music well below speech and never add unlicensed music.
- Check subtle camera shake in the source. When stabilization is useful, apply it to the camera layer before crops, B-roll, and captions; preserve natural head movement and use only the crop needed to hide moving edges.
- Do not fabricate screenshots, headlines, quotes, metrics, product interfaces, or article evidence. Clearly treat generated imagery as illustrative.
- Treat “viral” as an editorial direction: strong hook, escalating information, proof, and a clean payoff. Do not guarantee performance or misrepresent claims for retention.

## Safety and stopping conditions

- Ask before a new large Whisper model download or a paid media purchase unless already authorized in the conversation. Reusing an installed model needs no repeat approval.
- Do not download other creators' videos unless the creator has rights or the use is a brief, necessary quotation with source documentation.
- Never overwrite the original or an earlier final export. Version outputs as `final-v01.mp4`, `final-v02.mp4`, and so on.
- If transcription confidence is poor or a factual visual cannot be verified, flag the exact segment instead of guessing.
