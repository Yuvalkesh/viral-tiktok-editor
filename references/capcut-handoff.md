# Editable CapCut handoff

Use when the creator asks to review/continue editing in CapCut. The deliverable must contain independent source trims, B-roll, dialogue, music, and editable text. A flattened preview is useful alongside it, but cannot substitute for the project.

## Prefer native operations; inspect the installed version

Build/import through supported app operations where practical. If constructing a native draft programmatically, inspect a fresh minimal draft created by the installed version with sample video, audio, and text. Native JSON is an implementation detail, not a stable public API. Do not distribute another private project's JSON as a reusable template; it can contain device identifiers, local paths, and unrelated materials. Do not assume the former edit's templates or schema still apply.

Before external writes, save and close CapCut cleanly so its autosave cannot overwrite the changes. Back up the target project and any registry file to be modified. Work in a new project or version; preserve user manual edits. Generate fresh IDs for new project/material objects and keep media paths resolvable. If the installed version uses an unsupported/encrypted format, use the UI or a supported interchange route and describe any remaining limitation.

## CapCut 9.4 findings from a working edit (macOS)

The observed local project root was:

```text
~/Movies/CapCut/User Data/Projects/com.lveditor.draft
```

Verify its current location. In the observed multi-timeline schema:

- Root `draft_info.json` was insufficient: the active timeline loaded from `Timelines/<main_timeline_id>/draft_info.json`, identified by `Timelines/project.json`. Updating only root data produced a correct-looking project card but an old six-second timeline.
- Keep the root and active timeline data consistent, update duration/timestamps in the relevant metadata and timeline index, and preserve other timelines. Inspect `root_meta_info.json` only if registration requires it; never replace unrelated registry entries.
- Project `draft_id` and active timeline ID are distinct identities. Do not collapse them into one ID.
- `source_timerange` and `target_timerange` use microseconds. Build them from the shared frame-aligned EDL. Audio and video cuts must reference matching source times.
- Keep the full cleaned source audio as the material behind independently trimmed dialogue clips. Keep game music on its own track. A pre-ducked music track is editable as audio, but extending/reordering speech may require regenerating the ducking.
- CapCut text size units are not render pixels. In this layout an apparent 78px caption needed a native size near 13; 17 and 23.5 clipped long lines. This is a calibration example, not a fixed conversion. Preview the longest mixed-language cue and adjust within the installed version.
- The app may split overlapping labels/captions into separate text tracks. Validate material timing/content rather than relying on a fixed track count.

Do not copy a one-off generator with fixed old project names. Reuse the timeline logic, then adapt material and text structures from the fresh local template.

## Verify and package

Open the real project and confirm the total duration, beginning/middle/end, captions, B-roll, audio tracks, and absence of missing-media warnings. A home-screen card, launch command, or JSON parse is not sufficient evidence that the project works. Dismiss onboarding only as needed, refresh stale UI state, and stop once the requested project is visibly ready.

Save through CapCut, close cleanly if copying its files, then package the entire native project including the `Timelines` tree and metadata. Reopen the working project for the requested review handoff. If media references are absolute, tell the creator to keep the media folder in place; call a package portable only after collecting/relinking assets and verifying it opens from the packaged location.

Inspect native captions and exported captions separately. Disclose material differences such as caption animation or transitions when the native baseline does not exactly reproduce the polished FFmpeg master. Do not claim pixel-identical native export without comparing it.
