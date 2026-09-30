# Hebrew production mechanics

## Source and local ASR

Probe full stream metadata before rendering: stored width/height, rotation/display matrix, frame rate, color primaries, transfer function, and audio. An iPhone MOV stored as 1920x1080 may display vertically. A source marked BT.2020/HLG needs actual tone mapping to Rec.709 SDR; changing metadata alone washes out or misrepresents colors. Inspect the converted portrait before using it for the edit. Keep its time origin and duration aligned with the source transcript.

The verified local model for this workflow is (store it wherever you keep models and point `WHISPER_MODEL` at it):

```text
$WHISPER_MODEL  (e.g. ~/whisper-models/ggml-large-v3-turbo-q5_0.bin)
574041195 bytes
SHA256 394221709cd5ad1f40c46e6031ca61bce88931e6e088c188294c6d5a55ffa7e2
https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q5_0.bin
```

Verify an existing file before trusting it, particularly after an interrupted download. A similarly named unquantized `ggml-large-v3-turbo.bin` has been seen incomplete after an interrupted download; do not assume a filename implies a valid model. Preserve failed files until replacement is verified. A working small model can provide a provisional transcript while an authorized download completes; compare uncertain wording with the stronger pass.

`transcribe.sh` extracts mono 16 kHz PCM and runs Hebrew ASR. It selects DTW alignment for known small/turbo model names; set `WHISPER_DTW` for another verified architecture, or `none` to disable it. Set `WHISPER_LANGUAGE` when the source is not Hebrew. Raw output names must be new to preserve earlier passes.

Whisper.cpp `t_dtw` token timestamps are hundredths of a second. Word timing helps find false starts and pauses, but remains an estimate. Avoid prompt-heavy retranscription that hallucinates the expected sentence. Check mixed Hebrew/English names against actual project materials, then inspect/listen to uncertain boundaries. Do not insert facts from a reference article into the speaker's mouth.

## One timeline, separate texts

Maintain three distinct artifacts: raw ASR, corrected source-time transcript, and reordered spoken script with edited-time captions. Mark editorial cleanup rather than claiming a cleaned paraphrase is a verbatim transcript.

Use integer frame positions at the chosen frame rate, with half-open intervals `[in, out)`. Each ordered source range maps to one target range of equal length. Derive video, cleaned speech, subtitles, and editor clips from the same ranges. Quantize once; repeated float rounding causes boundary duplicates and drift. For a retained cue:

```text
target_start = section_target_start + cue_source_start - section_source_in
target_end   = section_target_start + cue_source_end   - section_source_in
```

If a cut intersects a cue, split/re-time the text at verified word boundaries; do not retain the whole sentence in a tiny clipped interval. Check for nonpositive durations, unintended overlapping captions, cues beyond export duration, and duplicated words where adjacent ranges meet. Preserve short natural breaths. Remove isolated hesitation only after checking the actual speech boundaries.

## RTL captions

Write short spoken phrases, generally 2–5 words, with one or two readable lines. Use actual word boundaries and timing rather than distributing a long sentence by character count. `captions_to_ass.py` preserves existing phrase timings by default. Its optional `--rechunk-words` estimates timing and is only for provisional drafts.

Start around 78px Alef Bold on a 1080x1920 canvas, white with dark stroke/shadow and restrained emphasis color. Measure the rendered longest line; split it before making text too small. Keep text above bottom controls, away from the right action rail, and clear of the face. Platform overlays vary, so these are visual checks, not permanent universal coordinates.

Use a renderer with proper Hebrew shaping/bidirectional support. Never reverse strings manually. Verify mixed Hebrew/English, digits, quotes, punctuation, and multi-line ordering in actual output frames.

If FFmpeg lacks the `subtitles`/libass filter, an alternative is transparent caption PNGs rendered with Pillow and RAQM, then a precisely timed alpha track (for example qtrle MOV) composited over video. Check RAQM availability first, preserve exact cue gaps, and inspect the final frames. Keep JSON/SRT and editable native text too; burned-in text alone is not editable caption delivery.

## Dialogue and soundtrack

Clean a full-length dialogue source conservatively before applying source cuts; this lets the editor extend trims later. High-pass near 80 Hz and gentle noise reduction are useful starting points, not mandatory filters. Apply tiny cut-edge fades where clicks occur without shaving consonants. Keep gameplay audio muted unless it is part of the story.

For a typical talking-head edit, dialogue near -16 LUFS and a game bed near -29 LUFS worked, with a little further music attenuation and speech-driven ducking. Starting sidechain settings were threshold .02, ratio 5, attack 15 ms, release 240 ms. Adjust by ear for each voice/music pair. Music fades at the opening/ending prevent abrupt entrances and tails.

With FFmpeg, `amix=normalize=0` avoids unexpected gain shifts; a limiter with `level=false` avoids automatic makeup gain. Measure the final encoded mix rather than assuming source normalization guarantees final loudness. A practical target is roughly -16 to -14 LUFS with true peak at or below -1 dBTP, subordinate to clear natural dialogue. Keep cleaned dialogue and music as separate native tracks.
