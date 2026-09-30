# Verification and delivery

For a normal vertical edit, deliver a versioned 1080x1920 H.264/AAC MP4 with Rec.709 SDR, 48 kHz audio, and faststart. Use an appropriate frame rate, commonly 30 fps. Preserve earlier exports. Deliver the corrected source transcript, reordered script, source/target edit decision list or timeline JSON, edited SRT, edit plan, and B-roll source manifest. Include the native project when requested.

Run `scripts/qa-video.sh` for dimensions, audio presence, positive duration, and decode. It does not check story quality, Hebrew layout, loudness, color appearance, or the native project. Also:

- Check orientation, color conversion, aspect ratio, black gaps, cut boundaries, and caption sync against the shared timeline.
- Inspect opening hook, representative game inserts, longest captions, mixed RTL/English text, and ending at phone-like scale.
- Listen to representative dialogue and transitions, check music intelligibility, and measure final loudness/true peak. State if subjective listening could not be performed.
- Verify native project duration/media/editability in the app if part of the delivery.

Record checks and unresolved limitations in a short QA note. Do not rerun all checks without a new change or unresolved issue; after a timing change, recheck affected boundaries and final duration/sync.

## Reel body text

When requested, create a UTF-8 `.txt` containing only the ready-to-copy Hebrew caption: a concrete opening, brief context/payoff, one appropriate CTA, and a few relevant hashtags. Keep claims consistent with the video and avoid invented results or metrics. Open it in TextEdit when asked and verify the correct document/content is visible. This request does not authorize posting.

## Optional browser distribution follow-up

Editing ends with local delivery unless the user separately asks for upload/publication. Preserve their stated draft-versus-publish choice across turns. “Post as a Reel” can specify format without overriding an earlier instruction to save as a draft; clarify only if the new wording actually changes or conflicts with that choice.

Use only the requested platforms and route. If the user says Instagram and TikTok directly, do not substitute Meta Business Suite. Read current browser tool documentation before upload actions. Complete authentication through the user's own login/verification flow, without collecting passwords, and verify the actual signed-in account.

Follow documented file-picker APIs. If browser automation is blocked by an extension conflict, refresh state or use supported visible-window controls. Coordinate with an actively used browser rather than repeatedly fighting tab changes. If file access is denied, report the exact blocker and required setting rather than claiming an upload succeeded.

A file attached to a composer is not a saved draft. Verify the saved item in the platform's draft list or equivalent explicit confirmation. If the desktop interface cannot save the requested draft, report that limit; never publish as a workaround. Respect stop requests immediately and report the verified state, distinguishing uploaded, unsaved composer, saved draft, and published.
