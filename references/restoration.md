# Speech restoration and camera stabilization

Use this reference when the recording sounds distant, reverberant or noisy, or when the creator requests better microphone sound or steadier framing. Reassess each new take; do not reuse the previous take's crop, timing, or audio diagnosis.

## Speech

Start from the original dialogue track, not an earlier music mix or encoded final. Inspect channel layout and routing first: duplicated or delayed voice tracks can create echo. Distinguish room reflections from background noise and from watery artifacts introduced by denoising. A high-pass filter, FFT denoiser, compressor, or LUFS pass alone is not dedicated dereverberation.

Compare a short speech sample with a dedicated restoration pass at matched loudness before processing the full recording. Preserve the person's identity, consonants, breaths, and Hebrew/English names. Do not replace the performance with TTS. Stronger processing is not automatically better. Avoid mixing a resynthesized waveform with the original unless sample alignment and phase behavior have been checked; this can create the very chorus/echo being removed.

If local restoration tooling is installed (for example an isolated Python environment with `nara_wpe`), inspect it and reuse verified weights rather than downloading again. A conservative non-generative option is [NARA-WPE](https://github.com/fgnt/nara_wpe), followed by modest noise reduction and EQ. Preserve sample alignment and test its strength against the dry source.

A Resemble Enhance stage2 trial on a Hebrew talking-head recording substantially degraded independent ASR of consonants and numbers despite passing duration, loudness and sync checks. It was rejected. Do not default to that model for Hebrew or treat a technically successful render as a successful restoration. Upstream is <https://github.com/resemble-ai/resemble-enhance>. On Apple Silicon, MPS also failed on a vocoder convolution with more than 65,536 output channels. These are troubleshooting facts, not a required workflow.

Process a continuous source with overlapping chunks if needed, then apply the common edit decision list. Verify output length, finite samples, chunk joins and algorithmic delay. Check local sync at several points as well as global delay. Use restrained EQ/compression after restoration, then measure the final encoded mix. Retain original and restored dialogue stems and a loudness-matched before/after sample.

Listen at the opening, a quiet phrase, a loud phrase, a chunk join, and the ending when audio listening is available. Compare independent unprompted ASR before and after processing as a supplementary intelligibility check; reject a pass that substantially damages words, consonants or numbers. Decode, ASR, loudness and waveform checks cannot certify a natural or high-quality microphone sound. If subjective listening is unavailable, say so clearly and provide the before/after sample; do not claim the voice was heard and approved.

## Camera

Estimate camera motion from static background features, masking the face, hands and other moving foreground objects. Smooth small rapid translations/rotations while retaining intentional camera movement. Reset estimation/smoothing across actual source discontinuities; never stabilize the already composited video because captions and evidence panels would move too.

Prefer a restrained global transform to aggressive mesh warping. Use a small fixed crop/zoom to cover exposed borders and inspect the strongest correction for reflected edges, face deformation and excessive cropping. Optical-flow confidence and a smoothed trajectory are diagnostics, not proof that the exported picture is steadier. Compare actual before/after frames or motion sequences and keep source/target timing unchanged.

## Repeated takes and pauses

Keep the completed sentence when the speaker restarts. Remove abandoned fragments and dead air using word timing plus speech boundaries; do not cut every breath or rely on a single silence threshold in a noisy room. Rebuild captions from the retained words so a discarded fragment does not survive as text. For a replacement recording, create a new project and derive all cuts and captions from that recording, even when reusing previously verified B-roll.
