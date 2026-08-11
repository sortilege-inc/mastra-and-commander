# Card Frame — Design Brief for Claude Design

**Goal:** produce a new **layered SVG card-frame set** for the trading card game
*Mastra & Commander*, replacing the current "Lens" frame. Output must drop into an existing
Squib rendering pipeline, so follow the **canvas, layering, and `spec.json` conventions** below
exactly.

## Canvas & print specs
- **Canvas:** 825 × 1125 px, full-bleed, at **300 dpi** (2.75 × 3.75 in with bleed).
- **Trim:** 750 × 1050 px (2.5 × 3.5 in poker card), centered → 37.5 px bleed on all sides.
- **Trim corner radius:** ~40 px.
- Design everything on this 825 × 1125 coordinate space.

## Visual style
**Clean, lighter, translucent sci-fi — "frosted glass / ice chrome."** Reference: Fantasy
Flight's *Arkham Horror LCG* meets *Android: Netrunner*, but **translucent and crisp**, not
aged. The frame material is a **pale, semi-transparent glassy bezel** with sharp beveled edges,
soft internal highlights, and high definition. Color and pop come from **saturated accent
lines and the art/fills** (teal, oxblood, gold, violet, neon cyan/magenta as accents) — **avoid
parchment, sepia, washed-out, or muddy tones.** Typography reads Netrunner: bold, condensed,
geometric. Keep it elegant and readable, not busy.

## Layout zones (approximate coordinates, refine as needed)
All boxes are `x, y, w, h` on the 825 × 1125 canvas; card center x = 412.5.

| Zone | x | y | w | h | notes |
|---|---|---|---|---|---|
| **Title bar** | 150 | 85 | 525 | 70 | top; holds card name |
| **Art window** | 180 | 195 | 465 | 505 | central; **beveled / octagonal** aperture |
| **Rules panel** | 170 | 720 | 485 | 250 | below art; rules text |
| **Left rail — Produce** | 40 | 360 | 85 | 360 | vertical; **5 evenly-spaced slots** |
| **Right rail — Consume/Cost** | 700 | 360 | 85 | 360 | vertical; **5 evenly-spaced slots** |
| **Bottom rail — Contributes** | 200 | 985 | 425 | 75 | horizontal; **3 evenly-spaced slots** |

**Slot centers** (these are what we composite icons onto — leave them as empty backings/anchors):
- Left rail (5): x ≈ 82; y ≈ 396, 468, 540, 612, 684
- Right rail (5): x ≈ 742; y ≈ 396, 468, 540, 612, 684
- Bottom rail (3): y ≈ 1022; x ≈ 271, 412, 554

**Important:** we supply our own icons at render time — **do not design specific icons.** Just
provide the rails and **empty slot backings** at those centers. The reference mockup's icons
are placeholders; only their *positions* matter.

## Required SVG layers (deliverables)
Provide **each layer as its own SVG, cropped to its own artwork**, positioned at a stated
origin on the 825 × 1125 canvas (same pattern as a print card-frame layer set). Suggested set:

- `guides.svg` — bleed / trim / safe-area / zone outlines (non-printing).
- `card-base.svg` — full-bleed background stock (825 × 1125).
- `frame.svg` — the translucent chrome bezel + rails structure + beveled art-window rim.
- `title-plate.svg` — the title bar plate.
- `art-window.svg` — the beveled art aperture frame (rim only).
- `aperture-mask.svg` — solid shape of the art window, for clipping artwork to it.
- `art-placeholder.svg` — a placeholder fill for the art window.
- `rules-panel.svg` — the lower rules panel plate.
- `rail-left.svg` — left rail with 5 empty slot backings.
- `rail-right.svg` — right rail with 5 empty slot backings.
- `rail-bottom.svg` — bottom rail with 3 empty slot backings.

## `spec.json` (required, machine-readable)
Mirror this shape so the pipeline can place everything:

```json
{
  "canvas": { "w": 825, "h": 1125, "dpi": 300 },
  "bleed": 37.5,
  "trim": { "x": 37.5, "y": 37.5, "w": 750, "h": 1050, "radius": 40 },
  "layers": {
    "card-base":       { "x": 0,   "y": 0,   "w": 825, "h": 1125 },
    "frame":           { "x": ..., "y": ..., "w": ..., "h": ... },
    "title-plate":     { "x": 150, "y": 85,  "w": 525, "h": 70 },
    "art-window":      { "x": 180, "y": 195, "w": 465, "h": 505 },
    "aperture-mask":   { "x": 180, "y": 195, "w": 465, "h": 505 },
    "rules-panel":     { "x": 170, "y": 720, "w": 485, "h": 250 },
    "rail-left":       { "x": 40,  "y": 360, "w": 85,  "h": 360 },
    "rail-right":      { "x": 700, "y": 360, "w": 85,  "h": 360 },
    "rail-bottom":     { "x": 200, "y": 985, "w": 425, "h": 75 },
    "guides":          { "x": 0,   "y": 0,   "w": 825, "h": 1125 }
  },
  "slots": {
    "produce":     [[82,396],[82,468],[82,540],[82,612],[82,684]],
    "consume":     [[742,396],[742,468],[742,540],[742,612],[742,684]],
    "contributes": [[271,1022],[412,1022],[554,1022]]
  },
  "textBoxes": {
    "title": { "x": 170, "y": 95,  "w": 485, "h": 52 },
    "rules": { "x": 190, "y": 740, "w": 445, "h": 210 }
  }
}
```

Fill in the `frame` origin/size and adjust any numbers to match the final art; keep the
**slot centers and text boxes accurate**, since the pipeline places icons and text by them.

## Conventions
- One artwork per SVG, cropped tight, positioned by its stated origin (so stacking them on the
  825 × 1125 canvas reassembles the card).
- Keep `guides.svg` non-printing.
- Prefer crisp vector shapes; no raster textures baked in.
- Deliver the SVGs + `spec.json`.
