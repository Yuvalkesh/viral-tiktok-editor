# B-roll sourcing and evidence

Use the narrowest source appropriate to the spoken claim.

## Footage over diagrams

Creator feedback from real edits: use fewer flowcharts, diagrams, and text-heavy explanatory cards, and more moving video footage that directly shows what he is talking about. Prioritize relevant real footage or demonstrations for each spoken beat, within the sourcing and rights rules below. Use evidence screenshots or compact fact cards sparingly when the exact claim needs them; do not default to cards merely because they are easier to produce. If suitable footage is unavailable, prefer keeping the speaker on screen over filling the sequence with diagrams.

## Preferred order

1. The creator's supplied footage, screen recordings, documents, and brand assets.
2. Official product pages, company press kits, public reports, or the cited article for evidence screenshots.
3. Stock footage with clear reusable licensing, such as Pexels, Pixabay, or Unsplash, when generic illustration is enough.
4. Original screen capture of a product or workflow when access is authorized.
5. Generated imagery for concepts that are inherently illustrative, never as documentary proof.

Search the web when a named article, company, person, study, product, or current fact is mentioned. Prefer primary sources. Record the direct URL and usage basis in `broll/sources.tsv`.

## Manifest format

Use tab-separated columns:

```text
start\tend\tfile\tsource_url\tusage_basis\tpurpose
```

For generated imagery, use `generated` as the URL and describe the prompt or concept in `usage_basis`. For the creator's local media, record the exact original local path and the authorization/ownership basis. User authorization to use a local file is not proof that all third-party IP in it is owned by the user.

## Game and product build stories

Search the relevant local project for actual gameplay captures, screenshots, concept art, and music before generating visuals. Only use projects the creator has authorized, and verify that paths and assets still exist. List your own project roots in a `local-projects.md` next to this file if you want the skill to find them automatically.

- Match the spoken game/mechanic to the insert. A roster image can establish characters; combat footage proves combat. Prefer actual game music for a game story when authorized, with gameplay audio muted unless deliberately mixed.
- If fresh capture is needed, use an isolated test/capture session. Preserve player saves and existing work. Record whether footage is staged QA, prototype, or ordinary gameplay; label it on screen where omission would mislead.
- Preserve pixel art edges and aspect ratio. Use measured cropping, letterboxing, or split composition instead of stretching landscape gameplay into portrait.
- A useful 1080x1920 composition from this workflow places 1080x608 gameplay near y=250, a 648px square face inset at x=216/y=900, and captions near y=1600. These are starting coordinates; adapt to the face, game HUD, text, and current platform UI.
- Slow pushes on actual screenshots or artwork can bridge beats. Generated gameplay must never stand in as evidence that the user's game has a feature.
- When recent game footage appears under a childhood memory, label it as the present-day build so it cannot be mistaken for historical footage.

## Boundaries

- Do not imply a stock actor is the real named person.
- Do not manufacture an article screenshot or alter headline wording.
- Avoid watermarked previews and unattributed social reposts.
- Keep quoted copyrighted video brief and necessary; prefer a still or official source when it communicates the point.
- Screenshots used as evidence must remain legible and include enough context to avoid misleading cropping.
